function getLocalEmailAddr()
  return string.format("%s@%s", env.USER, env.HOSTNAME)
end
