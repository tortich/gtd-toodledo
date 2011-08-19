require "toodledo"

load "slimtask.rb"

tasks = []

# Get tasks from file
File.open("notcomp-tasks.marshal") do |f|
  tasks = Marshal.load(f);
end

# Get projects on record from file
File.open

# Scan through all active tasks, and do the following:
#   1. Get a list of all active projects
#   2. Get a list of tasks without folder
#   3. Get a list of tasks without Context
#   4. Get a list of tasks without tags and _not_ in Someday context
#   5. Get a list of tasks in Someday context with tags
projects = []
tasks.uniq { |t| t.project }.each { |t|
  if !t.project.nil? then
    projects << { "project" => t.project, "folder" => t.folder }
  end
}
no_context_tasks = []
no_folder_tasks = []
no_project_tasks = []
someday_with_project_tasks = []
tasks.each { |t|
  if t.context.nil? then
    no_context_tasks << t
  end
  if t.folder.nil? then
    no_folder_tasks << t
  end
  if t.context == "Someday" && !t.project.nil? then
    someday_with_project_tasks << t
  end
  if t.project.nil? && t.context != "Someday" then
    no_project_tasks << t
  end
}

print "Active Projects\n"
projects.each { |p|
  print p["project"] + "\t" + p["folder"] +  "\n"
}
print "Tasks without context\n"
no_context_tasks.each { |t|
  print t.title + "\n"
}
print "Tasks without folder\n"
no_folder_tasks.each { |t|
  print t.title + "\n"
}
print "Tasks in Someday context with project\n"
someday_with_project_tasks.each { |t|
  print t.title + "\n"
}
print "Tasks without projects not in Someday context\n"
no_project_tasks.each { |t|
  print t.title + "\n"
}
