namespace :user do
  desc "Modifies a user and their privilages"
  task modify: :environment do |task, args|
    help, create = handle_flags(args.extras)
    args_hash = handle_args(create, args.extras)
    if help
      print_help_text
      abort
    end

    if args_hash.has_key? :login
      user = User.where("login = ?", args_hash[:login]).first
      if user and create
        abort '-create flag cannot be used on already existing user'
      elsif user
        args_hash.delete(:login)
        user.update!(args_hash)
        puts "User #{user.login} has been updated on the following fields: #{args_hash.to_s}"
      elsif create and not user
        User.create!(args_hash)
        puts "User #{args_hash[:login]} has been created with the following fields: #{args_hash.to_s}"
      else
        abort "User #{args_hash[:login]} could not be found, and --create flag was not set."
      end
    else
      abort 'Argument required: login'
    end

  end
end

def handle_flags(args)
  help = false
  create = false
  args.each do |arg|
    if arg == "--help"
      help = true
    elsif arg == "--create"
      create = true
    end
  end
  return help, create
end

def handle_args(create, args)
  args_hash = {}
  if create # Set arg hash defaults
    args_hash = {:admin => false, :manager => false, :director => false}
  end

  args.each do |arg|
    if arg.start_with? '--'
      next
    elsif arg =~ /(login|group)=\S+/ # Checks if non-bool user param.
      user_param, user_value = arg.split('=')
      if user_param == 'group'
        if UserGroups.get_user_groups_values.include? user_value
          args_hash[user_param.to_sym] = user_value
        else
          abort "Unknown group: #{user_value}. Invoke the --help flag to get a list of valid arguments."
        end
      else
        args_hash[user_param.to_sym] = user_value
      end
    elsif arg =~ /(admin|manager|director)=(true|false)/
      user_param, user_value = arg.split('=')
      args_hash[user_param.to_sym] = user_value.eql?('true') ? true : false
    else
      abort "Unknown argument: #{arg}. Invoke the --help flag to get a list of valid arguments."
    end
  end
  return args_hash
end

def print_help_text
  puts "Task is the format:"
  puts "rails user:modify[param=value,param=value,--flag]"
  puts ""
  puts "Valid arguments are as follows:"
  puts "login=string (Required)."
  puts "group=string (Optional, must match: #{UserGroups.get_user_groups_values.join("|")}."
  puts "admin=boolean (Optional)."
  puts "manager=boolean (Optional)."
  puts "director=boolean (Optional)."
  puts ""
  puts "Valid flags are as follows:"
  puts "--create (Initializes a user not already in database)."
  puts "--help (Prints this dialog)."
end
