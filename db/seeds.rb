# This file should ensure the existence of records required to run the application in every environment.

[
  [ "자유", "free", "가볍게 떠드는 공간입니다." ],
  [ "개발", "dev", "코드, 오류, 프로젝트 이야기를 나눕니다." ],
  [ "게임", "game", "플레이 후기와 공략을 공유합니다." ],
  [ "일상", "daily", "오늘 있었던 일과 잡담을 남깁니다." ],
  [ "질문", "question", "궁금한 것을 묻고 답을 찾습니다." ],
  [ "인터넷 방송", "internet-broadcasting", "인터넷 방송과 관련된 이야기를 나눕니다." ]
].each do |name, slug, description|
  Chapter.find_or_create_by!(slug: slug) do |chapter|
    chapter.name = name
    chapter.description = description
  end
end

default_chapter = Chapter.find_by!(slug: "free")
Post.where(chapter_id: nil).update_all(chapter_id: default_chapter.id)

User.where(nickname: nil).find_each do |user|
  base = user.username.presence || user.email_address.to_s.split("@").first.presence || "user#{user.id}"
  nickname = base
  suffix = 2

  while User.where.not(id: user.id).exists?(nickname: nickname)
    nickname = "#{base}#{suffix}"
    suffix += 1
  end

  user.update!(nickname: nickname)
end

if User.where(admin: true).none?
  User.order(:created_at).first&.update!(admin: true)
end
