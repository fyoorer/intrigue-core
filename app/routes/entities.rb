class IntrigueApp < Sinatra::Base
  namespace '/v1' do

    post '/:project/entities' do
      @entity_name = params[:entity_name]
      @page_id = params[:page]

      ## We have some very rudimentary searching capabilities here
      scoped_entities = Intrigue::Model::Entity.scope_by_project(@project_name)
      if @entity_name
        @entities = scoped_entities.all(:name.like => "%#{@entity_name}%").page(@page_id, :per_page => 50)
      else
        @entities = scoped_entities.page(@page_id, :per_page => 50)
      end

      erb :'entities/index'
    end

    get '/:project/entities' do
      @entity_name = params[:entity_name]
      @page_id = params[:page]

      ## We have some very rudimentary searching capabilities here
      scoped_entities = Intrigue::Model::Entity.scope_by_project(@project_name)
      if @entity_name
        @entities = scoped_entities.all(:name.like => "%#{@entity_name}%").page(@page_id, :per_page => 50)
      else
        @entities = scoped_entities.page(@page_id, :per_page => 50)
      end

      erb :'entities/index'
    end


   get '/:project/entities/:id' do
      @entity = Intrigue::Model::Entity.scope_by_project(@project_name).first(:id => params[:id])
      return "No such entity in this project" unless @entity

      @tasks = Intrigue::TaskFactory.list.map{|x| x.send(:new)}
      @task_names = @tasks.map{|t| t.metadata[:pretty_name]}.sort

      erb :'entities/detail'
    end

  end
end
