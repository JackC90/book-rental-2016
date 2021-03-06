class Product < ApplicationRecord
	include PgSearch
	include Filterable

	self.per_page = 16

	belongs_to :user
	has_many :orders, dependent: :destroy
	has_many :customers, through: :orders, source: :users
	has_many :reviews
	mount_uploaders :product_images, ProductImagesUploader

	validates :title, presence: true
	validates :category, presence: true
	validates :sale_or_rent, presence: true
	validates :price, presence: true
	validates :discount, inclusion: {in: 0..100}

	enum category: [:biology, :chemistry, :physics, :economics, :finance, :history, :literary_fiction, :fantasy, :scifi, :horror, :other]
	enum sale_or_rent: [:for_sale, :for_rent]
	enum format: [:paperback, :hardback, :other_formats]
	enum language: [:English, :Malay, :Chinese, :Tamil, :French, :Japanese, :other_languages]

	# Scopes for Searching
	pg_search_scope :search_string, :against => [:title, :description, :author, :isbn], using: {tsearch: {dictionary: "english"}}
	scope :category, 		-> (category) { where(category: category) }
	scope :sale_or_rent, 	-> (sale_or_rent) { where(sale_or_rent: sale_or_rent) }
	scope :ages, 			-> (ages) { where("ages >= ?", ages.to_i) }
	scope :price_above, 	-> (price) { where("price >= ?", price) }
	scope :price_below, 	-> (price) { where("price <= ?", price) }
	scope :product_format, 	-> (format) { where(format: format)}
	scope :language, 		-> (language) { where(language: language)}
	scope :academic, 		-> { where("category <= ?", 5) }
	scope :fiction, 		-> { where("category > ?", 5) }

	def average_rating
		average = self.reviews.average(:rating)
		if average.nil?
			average = 0
		else
			average.round
		end
	end
end
