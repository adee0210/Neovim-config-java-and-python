return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
        hints = { enabled = false },
        provider = "mistral",
        vendors = {
            mistral = {
                __inherited_from = "openai",
                api_key_name = "MISTRAL_API_KEY",
                endpoint = "https://api.mistral.ai/v1/",
                model = "mistral-large-latest",
                max_tokens = 32768,
            },
        },
    },
    build = "make",
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "echasnovski/mini.icons",
        "zbirenbaum/copilot.lua",
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                },
            },
        },
    },
}
