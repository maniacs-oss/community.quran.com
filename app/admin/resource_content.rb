ActiveAdmin.register ResourceContent do
  menu parent: "Content", priority: 10

  filter :approved
  filter :language
  filter :cardinality_type, as: :select, collection: -> do ResourceContent.collection_for_cardinality_type end
  filter :resource_type, as: :select, collection: -> do ResourceContent.collection_for_resource_type end
  filter :sub_type,  as: :select, collection: -> do ResourceContent.collection_for_sub_type end

  action_item :show, only: :show do
    link_to approve_admin_resource_content_path(resource), method: :put, data: {confirm: "Are you sure?"} do
      resource.approved? ? "Un Approve!" : "Approve!"
    end
  end

  member_action :approve, method: 'put' do
    resource.toggle_approve!

    redirect_to [:admin, resource], notice: resource.approved? ? 'Approved successfully' : 'Un approved successfully'
  end

  index do
    id_column

    column :author do |resource|
      link_to resource.author_name, admin_author_path(resource.author_id) if resource.author_id
    end

    column :language do |resource|
      link_to resource.language_name, admin_language_path(resource.language_id) if resource.language_id
    end

    column :name
    column :approved
    column :cardinality_type
    column :sub_type
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :approved
      row :language
      row :cardinality_type
      row :sub_type
      row :resource_type
      row :author
      row :data_source
    end
  end

  form do |f|
    f.inputs "Resource content Details" do
      f.input :name
      f.input :author_name
      f.input :approved
      f.input :language
      f.input :cardinality_type, as: :select, collection: ResourceContent.collection_for_cardinality_type
      f.input :resource_type, as: :select, collection: ResourceContent.collection_for_resource_type
      f.input :sub_type, as: :select, collection: ResourceContent.collection_for_sub_type
      f.input :author
      f.input :data_source

    end
    f.actions
  end

  permit_params do
    [:name, :author_name, :approved, :language_id, :cardinality_type, :resource_type, :sub_type, :author_id, :data_source_id]
  end

  def scoped_collection
    super.includes :language
  end

  sidebar "Data for this resource", only: :show do
    div do
      if resource.translation?
        link_to "Translations", "/admin/translations?utf8=%E2%9C%93&q%5Bresource_content_id_eq%5D=#{resource.id}"
      elsif resource.tafisr?
        link_to "Tafsir", "/admin/tafsirs?utf8=%E2%9C%93&q%5Bresource_content_id_eq%5D=#{resource.id}"
      elsif resource.transliteration?
        link_to "transliteration", "/admin/transliterations?utf8=%E2%9C%93&q%5Bresource_content_id_eq%5D=#{resource.id}"
      elsif resource.chapter_info?
        link_to "Chapter info", "/admin/chapter_infos?utf8=%E2%9C%93&q%5Bresource_content_id_eq%5D=#{resource.id}"
      elsif resource.video?
        link_to "Media content", "/admin/media_contents?utf8=%E2%9C%93&q%5Bresource_content_id_eq%5D=#{resource.id}"
      elsif resource.recitation?
        link_to "Audio recitations", "/admin/recitations?utf8=%E2%9C%93&q%5Bresource_content_id_eq%5D=#{resource.id}"
      end
    end
  end
end
