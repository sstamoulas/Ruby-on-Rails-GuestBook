class Person < ApplicationRecord
	validates_presence_of :secret,
		message: "must be provided so we can recognize you in the future"

	# ensure secret has enough letters, but not too many
	validates_length_of :secret, 
		in: 6..24

	# ensure secret contains at least one number
	validates_format_of :secret, 
		with: /[0-9]/,
		message: "must contain at least one number"

	# ensure secret contains at least one upper case
	validates_format_of :secret, 
		with: /[A-Z]/,
		message: "must contain at least one upper case character"

	# ensure secret contains at least one lower case
	validates_format_of :secret, 
		with: /[a-z]/, 
		message: "must contain at least one lower case character"

	# the coutnry field is a controlled vocabulary: we must check that
	# its value is within our allowed options
	# There is also a validates_exclusion_of method that is the oppposte
	validates_inclusion_of :country, 
		in: ['Canada', 'Mexico', 'UK', 'USA'], 
		message: "must be one of Canada, Mexico, UK or USA"

	# email should read like an email address; this check isn't exhaustive,
	# but it's a good start
	validates_format_of :email, 
		with: /\A(^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
		message: "doesn't look like a propert email address"

	# how do we recognize the same person coming back? by their email address
	# so we want to ensure the same person only signs in once
	# the scope: allows you to check uniquencess of multiple different columns, 
	# :email for email, :name for name and :secret for secret
	validates_uniqueness_of :email, 
		case_sensitive: false,
		scope: [:name, :secret],
		message: "has already been entered, you can't sign in twice"

	# Graduation year must be numeric, and within sensible bouds.
	# However, the person may not have graduated, so we allow a
	# nil value too. Finally, it must be a while number (integer).
	validates_numericality_of :graduation_year, 
		allow_nil: true,
		greater_than: 1920, 
		less_than_or_equal_to: Time.now.year,
		only_integer: true
		#equal_to:
		#even: true or false, default is false
		#greater_than:
		#greater_than_or_equal_to:
		#less_than:
		#less_than_or_equal_to:
		#odd: true or false, default is false

	# Body temperature doesn't have to be a whole number, but we ought to 
	# constrain possible values. We assume our users aren't in cryostasis.
	validates_numericality_of :body_temperature,
		allow_nil: true,
		greater_than_or_equal_to: 60,
		less_than_or_equal_to: 130,
		only_integer: false

	validates_numericality_of :price,
		allow_nil: true,
		only_integer: false

	# Restrict birthday to reasonable values, i.e., not in the future and not
	# Before 1900
	validates_inclusion_of :birthday, 
		in: Date.civil(1900, 1, 1) .. Date.today, 
		message: "must be between January 1st, 1990 and today"

	# Finally, we just say that favorite time is mandatory.
	# While the view only allows you to post valid times, remember
	# that models can be created in other ways, such as from code
	# or web service calls, so it's not safe to make assumptions
	# based on the form.
	validates_presence_of :favorite_time

	# if person says can send email, then we'd like them to fill their
	# description in, so we understand who it is we're sending mail to
	validates_presence_of :description, 
		if: :require_description_presence?

	# we define the supporting condition here
	def require_description_presence?
		self.can_send_email
	end

	validate :description_length_words

	def description_length_words
		# only do this validation if description is provided
		unless self.description.blank? then
			# simple way of calculating words: split the text on whitespace
			num_words = self.description.split.length
			if num_words < 5 then
				self.errors.add(:description, "must be at least 5 words long")
			elsif num_words > 50 then
				self.errors.add(:description, "must be at most 50 words long")
			end
		end
	end
end
