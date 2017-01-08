class Users::RegistrationsController < Devise::RegistrationsController
  # Extend default Devise gem behavior so that user sign up for the 
  # Pro Account (plan id 2) saves with s special Stripe subscription function.
  # Otherwise Devise signs up user as usual (basic user).
  def create
    super do |resource|
      if params[:plan]
        resource.plan_id = params[:plan]
        if resource.plan_id == 2
          resource.save_with_subscription
        else
          resource.save
        end
      end
    end
  end
end