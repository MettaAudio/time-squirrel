require "spec_helper"

describe TimersController do
  describe "routing" do

    it "routes to #index" do
      get("/timers").should route_to("timers#index")
    end

    it "routes to #new" do
      get("/timers/new").should route_to("timers#new")
    end

    it "routes to #show" do
      get("/timers/1").should route_to("timers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/timers/1/edit").should route_to("timers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/timers").should route_to("timers#create")
    end

    it "routes to #update" do
      put("/timers/1").should route_to("timers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/timers/1").should route_to("timers#destroy", :id => "1")
    end

  end
end
