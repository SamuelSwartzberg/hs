local small_words = {
  "a", "an", "and", "as", "at", "but", "by", "en", "for", "if", "in", "of", "on", "or", "the", "to", "v", "v.", "via", "vs", "vs."
}

local word_separators = {
  " ", ":", "–", "—", "-", "\t", "\n"
}

---@param word string
---@return string
function firstCharToUpper(word)
  local index_of_first_letter = eutf8.find(word, "%a")
  if index_of_first_letter then
    local first_letter = eutf8.sub(word, index_of_first_letter, index_of_first_letter)
    local rest_of_word = eutf8.sub(word, index_of_first_letter + 1)
    return eutf8.upper(first_letter) .. rest_of_word
  else
    return word
  end
end

---@param word string
---@return string
function titleCaseWordNoContext(word)
  if find(small_words, word) then
    return word
  elseif eutf8.find(word, "%u") then -- words with uppercase letters are presumed to already be correctly title cased (acronyms, brands, the like)
    return word
  else
    return firstCharToUpper(word)
  end
end

---@param str string
---@return string
function toTitleCase(str)
  local words = splitByMultiple(str, word_separators)
  local title_cased_words = map(words, titleCaseWordNoContext)
  title_cased_words[1] = firstCharToUpper(title_cased_words[1])
  title_cased_words[#title_cased_words] = firstCharToUpper(title_cased_words[#title_cased_words])
  -- it would be tempting to think that we could just join the words with a space, but that would normalize all word separators to spaces, which is not what we want, so we have to search for the correct occurrence of the non-capitalized word and replace it with the capitalized version
  local current_position_in_str = 1
  local original_str_lower = eutf8.lower(str)
  for index, word in ipairs(words) do
    local word_lower = eutf8.lower(word)
    local word_position_in_str = eutf8.find(original_str_lower, word_lower, current_position_in_str, true)
    if word_position_in_str then
      str = eutf8.sub(str, 1, word_position_in_str - 1) .. title_cased_words[index] .. eutf8.sub(str, word_position_in_str + #word_lower)
      current_position_in_str = word_position_in_str + #title_cased_words[index]
    else 
      error("Capitalized word is somehow not in the original string")
    end
    
  end
  return str
end
