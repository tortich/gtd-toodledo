require 'rubygems'
require 'toodledo'
require 'date'

load 'slimtask.rb'

# File containing the following (not kept in repository). Format:
# $key_user_id = "USER ID"
# $key_password = "PASSWORD"
#
load "keyconf.rb"

config = {
  "connection" => {
    "url" => "http://www.toodledo.com/api.php",
    "user_id" => $key_user_id,
    "password" => $key_password
  }
}

FOLDERS = ['Projects', 'Household', 'Personal', 'HCI', 'Community']
CONTEXTS = ['Agendas', 'Calls', 'Computer', 'Email', 'Errands', 'Home',
            'Someday', 'WorkOffice', nil]

#log = Logger.new(STDOUT)
#log.level = Logger::DEBUG

Toodledo.set_config(config)

open_tasks = []
closed_tasks = []
Toodledo.begin do |session|
  for folder in FOLDERS
    for context in CONTEXTS
      open_tasks += session.get_tasks({:notcomp => true,
                                       :context => context,
                                       :folder => folder})
      closed_tasks += session.get_tasks({:notcomp => false,
                                         :compafter => (Date.today - 6 * 30).strftime("%Y-%m-%d"),
                                         :context => context,
                                         :folder => folder})
      if folder.nil? then folder = "" end
      if context.nil? then context = "" end
      print "Folder - " + folder + "; Context - " + context + "; Open task tally - " +
          open_tasks.length.to_s + "\n"
      print "Folder - " + folder + "; Context - " + context + "; Closed task tally - " +
          open_tasks.length.to_s + "\n"
    end
  end
end
print "Toodledo open tasks: " + open_tasks.length.to_s + "\n"
open_slimtasks = []
open_tasks.each { |task|
  open_slimtasks << SlimTask.new(task.title,
                                 task.note,
                                 task.context.name,
                                 task.folder.name,
                                 task.tag,
                                 task.completed,
                                 task.added,
                                 task.priority,
                                 task.modified)
}
print "Toodledo tasks closed last 6 months: " + closed_tasks.length.to_s + "\n"
closed_slimtasks = []
closed_tasks.each { |task|
  closed_slimtasks << SlimTask.new(task.title,
                                  task.note,
                                  task.context.name,
                                  task.folder.name,
                                  task.tag,
                                  task.completed,
                                  task.added,
                                  task.priority,
                                  task.modified)
}

File.open("notcomp-tasks.marshal", "w+") do |f|
  Marshal.dump(open_slimtasks, f);
end

File.open("comp-tasks.marshal", "w+") do |f|
  Marshal.dump(closed_slimtasks, f);
end
