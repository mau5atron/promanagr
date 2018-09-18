class ConfirmationsController < Devise::ConfirmationsController

	# this updates (PUT) under the route /resource/confirmation
	def update 
		with_unconfirmed_confirmable do 
			if @confirmable.has_no_password?
				@confirmable.attempt_set_password(params[:user])
				if @confirmable.valid? and @confirmable.password_match?
					# if password is valid and password matches, allow user to confirm password
					do_confirm
				else 
					# display errors 
					do_show
					@confirmable.errors.clear
					# displays erros instead of rendering the :new template 
				end
			else 
				@confirmable.errors.add(:email, :password_already_set)
			end
		end

		if !@confirmable.errors.empty? 
			self.resource = @confirmable
			redirect_to 'devise/confirmations/new'
		end
	end

	def show
		with_unconfirmed_confirmable do 
			if @confirmable.has_no_password?
				do_show
			else
				do_confirm
			end
		end

		unless @confirmable.errors.empty? 
			self.resource = @confirmable
			render 'devise/confirmations/new'
		end
	end

	protected 

	def with_unconfirmed_confirmable
		@confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
		if !@confirmable.new_record?
			@confirmable.only_if_unconfirmed { yield }
		end
	end

	def do_show
		@confirmation_token = params[:confirmation_token]
		@requires_password = true
		self.resource = @confirmable
		render 'devise/confirmations/show'
	end

	def do_confirm
		@confirmable.confirm
		set_flash_message :notice, :confirmed
		sign_in_and_redirect(resource_name, @confirmable)
	end
end