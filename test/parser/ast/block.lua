local function TEST(code)
    return function (expect)
        ---@class LuaParser.Ast
        local ast = New 'LuaParser.Ast' (code)
        local node = ast:parseState()
        assert(node)
        Match(node, expect)
    end
end

TEST [[
do
    x = 1
    y = 2
end
]]
{
    kind   = 'do',
    left   = 0,
    right  = 30003,
    childs = {
        [1] = {
            kind   = 'assign',
            left   = 10004,
            right  = 10009,
        },
        [2] = {
            kind   = 'assign',
            left   = 20004,
            right  = 20009,
        },
    }
}

TEST [[
do
    local x = x
    x = 1
    print(x)
end
]]
{
    childs = {
        [1] = {
            kind   = 'localdef',
            vars   = {
                [1] = {
                    id   = 'x',
                    sets = {
                        [1] = {
                            left = 20004,
                        }
                    },
                    gets = {
                        [1] = {
                            left = 30010,
                        }
                    },
                    value = {
                        loc = NIL,
                    }
                },
            },
        },
        [2] = {
            kind = 'assign',
            exps = {
                [1] = {
                    id  = 'x',
                    loc = {
                        left = 10010,
                    }
                }
            }
        },
        [3] = {
            kind = 'call',
            args = {
                [1] = {
                    id  = 'x',
                    loc = {
                        left = 10010,
                    }
                }
            }
        },
    }
}

TEST [[
do
    local x
    do
        local x = x
        print(x)
    end
end
]]
{
    kind = 'do',
    childs = {
        [1] = {
            kind = 'localdef',
            vars = {
                [1] = {
                    id = 'x',
                }
            }
        },
        [2] = {
            kind = 'do',
            childs = {
                [1] = {
                    kind = 'localdef',
                    vars = {
                        [1] = {
                            id = 'x',
                        }
                    },
                    values = {
                        [1] = {
                            id = 'x',
                            loc = {
                                left = 10010,
                            }
                        }
                    }
                },
                [2] = {
                    kind = 'call',
                    args = {
                        [1] = {
                            id = 'x',
                            loc = {
                                left = 30014,
                            }
                        }
                    }
                }
            }
        }
    }
}

TEST [[
do
    local x
    if x then
        local x = x
        print(x)
    elseif x then
        local x = x
        print(x)
    else
        local x = x
        print(x)
    end
end
]]
{
    kind = 'do',
    childs = {
        [1] = {
            kind = 'localdef',
            vars = {
                [1] = {
                    id = 'x',
                }
            }
        },
        [2] = {
            kind = 'if',
            childs = {
                [1] = {
                    subtype = 'if',
                    condition = {
                        id = 'x',
                        loc = {
                            left = 10010,
                        }
                    },
                    childs = {
                        [1] = {
                            kind = 'localdef',
                            vars = {
                                [1] = {
                                    id = 'x',
                                }
                            },
                            values = {
                                [1] = {
                                    id = 'x',
                                    loc = {
                                        left = 10010,
                                    }
                                }
                            }
                        },
                        [2] = {
                            kind = 'call',
                            args = {
                                [1] = {
                                    id = 'x',
                                    loc = {
                                        left = 30014,
                                    }
                                }
                            }
                        }
                    }
                },
                [2] = {
                    subtype = 'elseif',
                    condition = {
                        id = 'x',
                        loc = {
                            left = 10010,
                        }
                    },
                    childs = {
                        [1] = {
                            kind = 'localdef',
                            vars = {
                                [1] = {
                                    id = 'x',
                                }
                            },
                            values = {
                                [1] = {
                                    id = 'x',
                                    loc = {
                                        left = 10010,
                                    }
                                }
                            }
                        },
                        [2] = {
                            kind = 'call',
                            args = {
                                [1] = {
                                    id = 'x',
                                    loc = {
                                        left = 60014,
                                    }
                                }
                            }
                        }
                    }
                },
                [3] = {
                    subtype = 'else',
                    childs = {
                        [1] = {
                            kind = 'localdef',
                            vars = {
                                [1] = {
                                    id = 'x',
                                }
                            },
                            values = {
                                [1] = {
                                    id = 'x',
                                    loc = {
                                        left = 10010,
                                    }
                                }
                            }
                        },
                        [2] = {
                            kind = 'call',
                            args = {
                                [1] = {
                                    id = 'x',
                                    loc = {
                                        left = 90014,
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

TEST [[
for i = 1, 10 do
    print(i)
end
]]
{
    childs = {
        [1] = {
            kind = 'call',
            args = {
                [1] = {
                    id = 'i',
                    loc = {
                        left = 4,
                    }
                }
            }
        }
    }
}

TEST [[
for k, v in pairs(t) do
    print(k, v)
end
]]
{
    childs = {
        [1] = {
            kind = 'call',
            args = {
                [1] = {
                    id = 'k',
                    loc = {
                        left = 4,
                    }
                },
                [2] = {
                    id = 'v',
                    loc = {
                        left = 7,
                    }
                }
            }
        }
    }
}

TEST [[
while true do
    local x
    print(x)
end
]]
{
    childs = {
        [1] = {
            kind = 'localdef',
            vars = {
                [1] = {
                    id = 'x',
                }
            }
        },
        [2] = {
            kind = 'call',
            args = {
                [1] = {
                    id = 'x',
                    loc = {
                        left = 10010,
                    }
                }
            }
        }
    }
}

TEST [[
do
    local x
    repeat
        local x
    until x
end
]]
{
    childs = {
        [1] = {
            kind = 'localdef',
            vars = {
                [1] = {
                    id = 'x',
                }
            }
        },
        [2] = {
            kind = 'repeat',
            condition = {
                id = 'x',
                loc = {
                    left = 30014,
                }
            },
            childs = {
                [1] = {
                    kind = 'localdef',
                    vars = {
                        [1] = {
                            id = 'x',
                        }
                    }
                }
            }
        }
    }
}

TEST [[
function (x, y)
    print(x, y)
end
]]
{
    params = {
        [1] = {
            id = 'x'
        },
        [2] = {
            id = 'y'
        }
    },
    childs = {
        [1] = {
            kind = 'call',
            args = {
                [1] = {
                    id = 'x',
                    loc = {
                        left = 10,
                    }
                },
                [2] = {
                    id = 'y',
                    loc = {
                        left = 13,
                    }
                }
            }
        }
    }
}

TEST [[
local function f()
    print(f)
end
]]
{
    childs = {
        [1] = {
            kind = 'call',
            args = {
                [1] = {
                    id = 'f',
                    loc = {
                        left = 15,
                    }
                },
            }
        }
    }
}

TEST [[
local function a()
    return
end]]
{
    kind = 'function',
    childs = {
        [1] = {
            kind = 'return',
            exps = {
                [1] = NIL
            }
        }
    }
}

TEST [[
local function f()
    return f
end
]]
{
    kind = 'function',
    childs = {
        [1] = {
            kind = 'return',
            exps = {
                [1] = {
                    kind = 'var',
                    id   = 'f',
                    loc  = {
                        left = 15,
                    }
                }
            }
        }
    }
}
