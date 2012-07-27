class Article < ActiveRecord::Base
  attr_accessible :title, :body, :tag_list, :image

  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings

  has_attached_file :image

  def tag_list
    return self.tags.join(", ")
  end

  def tag_list=(tags_string)
    self.taggings.destroy_all

    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq

    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name)
      tagging = self.taggings.new
      tagging.tag_id = tag.id
    end
  end

  def self.only(params) 
    ordering = {'word_count' => 'length(body) DESC', 'published' => 'created_at ASC' , 'title' => 'title'}
    if params[:limit].to_i > 0
      return Article.order(ordering[params[:order_by]]).limit(params[:limit].to_i)
    else
      return Article.order(ordering[params[:order_by]])
    end
    # @articles = Article.order(ordering[params[:order_by]])
    # @articles = @articl

  end

  def self.ordered_by(param)
      if param == 'title'
        @articles = Article.order('title')
      elsif param == 'published'
        @articles = Article.order('created_at ASC')
      elsif param == 'word_count'
        @articles = Article.order('length(body) DESC')
      else 
        @articles = Article.all
      end
  end
end
