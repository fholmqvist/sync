require "process"

def git_log
  process_out_err("git", ["log", "--oneline"])
end

def git_add
  process_err("git", ["add", "."])
end

def git_commit(commit_number)
  process_err("git", ["commit", "-m", commit_number.to_s])
end

def git_push
  process_err("git", ["push"])
end

def process_out_err(command, args)
  result_out, result_in = IO.pipe
  err_out, err_in = IO.pipe

  Process.run(command, args, output: result_in, error: err_in)
  result_in.close
  err_in.close

  log = result_out.try(&.gets_to_end)
  err = err_out.try(&.gets_to_end)

  return log, err
end

def process_err(command, args)
  err_out, err_in = IO.pipe

  Process.run(command, args, error: err_in)
  err_in.close

  err = err_out.try(&.gets_to_end)

  return err
end