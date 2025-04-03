return {
    "olimorris/codecompanion.nvim",
    config = function()
        require("codecompanion").setup({
            adapters = {
                openrouter = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        env = {
                            api_key = "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",
                            url = "https://openrouter.ai/api",
                            chat_url = "/v1/chat/completions",
                        },
                        schema = {
                            model = {
                                default = "deepseek/deepseek-chat-v3-0324:free",
                                required = true
                            },
                            temperature = {
                                default = 0.3,
                                validate = function(v) return v >= 0 and v <= 1 end
                            },
                            max_tokens = {
                                default = 8192,
                                validate = function(v) return type(v) == "number" and v >= 1 end
                            }
                        },
                        handle_rate_limit = function()
                            vim.notify("Đạt giới hạn 10 requests/10s. Chờ 10 giây...", vim.log.levels.WARN)
                            vim.wait(10000)
                            return true
                        end
                    })
                end
            },
            display = {
                chat = {
                    intro_message = "Welcome to DeepSeek V3!",
                    window = {
                        width = 75,
                    }
                }
            }
        })
    end
}
