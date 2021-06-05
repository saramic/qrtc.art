class Location < ApplicationRecord
  has_many :visits, dependent: :destroy
  enum status: {pending: 0, active: 1, archived: 2}

  scope :active_sample, -> { where(status: "active").sample&.id || "" }

  def url
    Location.url_for(id)
  end

  def qr_svg
    Location.qr_svg_for(id)
  end

  def self.url_for(location_id)
    uri = URI.parse(Rails.application.config.qrtc_base_url)
    uri.path = "/#{location_id}"
    uri.to_s
  end

  def self.qr_svg_for(location_id)
    qrcode = RQRCode::QRCode.new(url_for(location_id))
    qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    ).html_safe
  end
end
