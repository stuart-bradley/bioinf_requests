# Validates status by checking it is assigned correctly
# Stuart Bradley
# 30/1/2015
#
# if and unless are
# fairly straightforward, unless 
# they're being iffy.

class OngoingValidator < ActiveModel::Validator 
  def validate(record)
  	status = record.status
    assignment = record.assignment ? record.assignment : ""
  	if status != "Pending" && assignment.length < 2
  		record.errors[:status] << "'#{status}', cannot be applied without an assigned user."
  	end
  end
end