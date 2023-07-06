
-- build multiple headers

-- fake headers

assertMessage(
  transf.dict.email_header({
    foo = "bar",
    baz = "qux",
  }),
  "Baz: qux\nFoo: bar"
)

-- real headers (are auto-sorted)

assertMessage(
  transf.dict.email_header({
    subject = "test",
    from = "test@example.com",
    to = "test2@example.com",
  }),
  "From: test@example.com\nTo: test2@example.com\nSubject: test"
)

-- mixture of real and fake headers

assertMessage(
  transf.dict.email_header({
    foo = "bar",
    baz = "qux",
    subject = "test",
    from = "test@example.com",
    to = "test2@example.com"
  }),
  "From: test@example.com\nTo: test2@example.com\nSubject: test\nBaz: qux\nFoo: bar"
)

-- build email

assertMessage(
  join.string.table.email({
    foo = "bar",
    baz = "qux",
    subject = "test",
    from = "test@example.com",
    to = "test2@example.com"
  }, "hello world"),

  "From: test@example.com\nTo: test2@example.com\nSubject: test\nBaz: qux\nFoo: bar\n\nhello world"
)

-- build email interactive

buildEmailInteractive({
  foo = "bar",
  baz = "qux",
  subject = "test",
  from = "test@example.com",
    to = "test2@example.com"
  }, [[Hello,

This is a test email. It will never be sent.
Find attached the file you didn't ask for.
{{[transf.path.attachment("/Library/User Pictures/Flowers/Dahlia.tif")]}}

Cheers!]],  nil, function(mail)
  local contents = readFile(mail)
  assert(
    stringy.startswith(
      contents, 
      [[From: test@example.com
To: test2@example.com
Subject: test
Baz: qux
Foo: bar
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=]]
    )
  )
end)

