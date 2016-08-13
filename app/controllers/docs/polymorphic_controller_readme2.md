Models:

 class Member < ActiveRecord::Base
   has_one :address, as: :person, dependent: :destroy
 end

 class Dependent < ActiveRecord::Base
   has_one :address, as: :person, dependent: :destroy
 end

 class Address < ActiveRecord::Base
    belongs_to :person, polymorphic: true
 end


 class AddressesController < ApplicationController  
  before_action :set_person

  def new
    @address = @person.build_address
  end

  def set_person
    klass = [Member, Dependent].detect{|c| params["#{c.name.underscore}_id"]}
    @person= klass.find(params["#{klass.name.underscore}_id"])
  end
end


As for your routes file, currently according to the relationships that you have defined in your models the following should work:

resources :members do
 resource :address #singular resource routing as its a has_one relationship
end

resources :dependents do
  resource :address #singular resource routing as its a has_one relationship
end
(Notice that I have used singular routing for nested resource. You can read more on it here : http://guides.rubyonrails.org/routing.html#singular-resources)