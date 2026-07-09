module ApplicationHelper
  # 댓글 안의 [아나콘:첨부ID] 토큰을 승인된 아나콘 이미지로 바꿔서 보여줍니다.
  def render_comment_body(body)
    text = body.to_s
    ids = text.scan(/\[아나콘:(\d+)\]/).flatten.map(&:to_i)
    attachments = ActiveStorage::Attachment.includes(:blob, :record)
      .where(id: ids, record_type: "Anacon", name: "images")
      .index_by(&:id)

    pieces = text.split(/(\[아나콘:\d+\])/).filter_map do |piece|
      match = piece.match(/\A\[아나콘:(\d+)\]\z/)

      if match
        attachment = attachments[match[1].to_i]
        next unless attachment&.record&.approved?

        image_tag(attachment, class: "inline-anacon", alt: attachment.record.title, title: attachment.record.title)
      elsif piece.present?
        simple_format(piece)
      end
    end

    safe_join(pieces)
  end
end
