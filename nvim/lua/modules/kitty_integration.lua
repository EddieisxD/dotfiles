local kitty = {}

function kitty.is_kitty()
    return os.getenv("TERM") == "xterm-kitty"
end

function kitty.apply()
    -- TODO
end

return kitty
