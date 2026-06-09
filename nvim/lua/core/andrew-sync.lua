-- Setup syncing between CMU servers and local for classwork
local sync_pairs = {
    { local_base = "/Users/jasperdavidson/code/school/15122/", remote_base = "/afs/andrew.cmu.edu/usr/jjdavids/private/15122/" },
    { local_base = "/Users/jasperdavidson/code/school/18213/", remote_base = "/afs/andrew.cmu.edu/usr/jjdavids/private/18213/" },
}

for _, pair in ipairs(sync_pairs) do
    vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = pair.local_base .. "**",
        callback = function()
            local local_file = vim.fn.expand("%:p")
            local relative_path = local_file:sub(#pair.local_base + 1)
            vim.fn.jobstart({ "rsync", "-az", local_file, "jjdavids@linux.andrew.cmu.edu:" .. pair.remote_base .. relative_path }, {
                on_exit = function(_, exit_code, _)
                    print(exit_code == 0 and "Synced to Andrew!" or "Sync FAILED: Check your SSH Master connection")
                end,
            })
        end,
    })
end
