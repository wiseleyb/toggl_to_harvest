#!/usr/bin/env ruby

# Harvest format http://www.getharvest.com/help/account-settings/managing-account-settings/importing-and-exporting-data
# Date (YYYY-MM-DD or M/D/YYYY formats. For example: 2008-08-25 or 8/25/2008)
# Client
# Project
# Task
# Note
# Hours (in decimal form, without any stray characters. For example: 7.5, 3, 9.9)
# First name
# Last name

# Toggl format
# 0-User,1-Client,2-Project,3-Description,4-Billable,5-Start time,6-End time,7-Duration,8-Tags,9-Task,10-Amount (USD)
# Rain48,CatalogChoice,catalogchoice.org,braintree,Yes,06/21/2011 14:43,06/21/2011 17:28,02:45:20,"","",220.44

require 'csv'
require 'date'
fname = $*.delete_at(0)
fout = fname.gsub(".csv", "_harvest.csv")
output = ["date, client, project, task, note, hours, first name, last name".split(",")]
CSV.foreach(fname) do |row|
  unless row[0] == "User"
    tmp = row[7].split(":")
    time = sprintf('%0.2f',tmp[0].to_f + (tmp[1].to_f/60.0))
    date = DateTime.parse(row[5]).strftime("%Y-%m-%d")
    output << [date, row[1], row[2], row[3], "", time, "Ben", "Wiseley"]
  end
end
`touch #{fout}`
`rm #{fout}`
CSV.open(fout, "wb") do |csv|
  output.each do |row|
    csv << row
  end
end
puts `cat #{fout}`