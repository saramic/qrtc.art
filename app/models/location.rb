class Location < ApplicationRecord
  LOCATION_CODE_LENGTH = 4
  has_many :visits, dependent: :destroy
  enum status: {pending: 0, active: 1, archived: 2}

  scope :active_sample, -> { where(status: "active").where.not(code: nil).sample }
  validates :code, presence: true
  validates :code, length: { is: LOCATION_CODE_LENGTH }
  validates :code, uniqueness: true

  def hash_tag_text
    [
      [name, address].reject(&:empty?).join(", "),
      "#qrtc",
      "#QRTC_art",
      "#qrtc_#{code}",
      "##{code}"
    ].join(" ")
  end

  def url
    Location.url_for(id)
  end

  def qr_svg
    Location.qr_svg_for(id)
  end

  def self.url_for(location_id)
    uri = URI.parse(Rails.application.config.qrtc_base_url)
    uri.path = "/qr/#{location_id}"
    uri.to_s
  end

  def self.qr_svg_for(location_id)
    qrcode = RQRCode::QRCode.new(url_for(location_id))
    qrcode.as_svg(
      color: "212121",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true,
      viewbox: "0 0 500 500"
    ).html_safe
  end

  def set_code
    self.code ||= generate_code
  end

  private

  def generate_code
    loop do
      new_code = SecureRandom.alphanumeric(LOCATION_CODE_LENGTH)
      break new_code unless Location.where(code: new_code).exists?
    end
  end
end
