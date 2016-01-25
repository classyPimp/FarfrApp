class ContractAttachmentsController < ApplicationController

  SEND_FILE_METHOD = :default

  def download
    
    search_id = params[:id1] + params[:id2] + params[:id3] 
    head(:not_found) and return if (document = ContractAttachment.find(search_id.to_i)).nil?
    
    path = document.document.path(params[:style])
    head(:bad_request) and return unless File.exist?(path) && params[:format].to_s == File.extname(path).gsub(/^\.+/, '')

    send_file_options = { :type => document.document.content_type }

    case SEND_FILE_METHOD
      when :apache then send_file_options[:x_sendfile] = true
      when :nginx then head(:x_accel_redirect => path.gsub(Rails.root, ''), :content_type => send_file_options[:type]) and return
    end

    send_file(path, send_file_options)
    #taken from:
    #http://thewebfellas.com/blog/2009/8/29/protecting-your-paperclip-downloads
  end

  def create
    render plain: params and return
    if ContractAttachment.create(params_for_signed_scans)
      render plain: "ok"
    else
      render plain: "error"
    end
  end

#----------NON-ACTION METHODS

  def params_for_signed_scans
    require(:attachment).permit([:document, :is_scan])
  end
 
end
