Rails.application.routes.draw do
  # 회원가입, 로그인, 프로필, 사이트 설정처럼 앱 전체에서 쓰는 기본 주소들입니다.
  resource :registration, only: %i[ new create ]
  resource :profile, only: %i[ show edit update ]
  resource :site_setting, only: %i[ edit update ], path: "settings"
  resources :uploads, only: %i[ create show ]
  resources :reports, only: %i[ create ]
  resources :user_anacons, only: %i[ create destroy ]
  resources :notifications, only: %i[ index ] do
    collection do
      patch :mark_all
    end
  end

  # 아나콘은 게시글/댓글에 붙여 쓰는 이미지 묶음입니다. 등록 후 관리자 승인을 받아야 사용할 수 있습니다.
  resources :anacons, only: %i[ index show new create ]

  # 운영자 전용 관리 화면입니다. 신고 확인, 아나콘 승인, 콘텐츠 삭제, 유저 차단을 처리합니다.
  namespace :admin do
    root "reports#index"
    resources :reports, only: %i[ index update ]
    resources :anacons, only: %i[ index update destroy ]
    resources :posts, only: %i[ destroy ]
    resources :comments, only: %i[ destroy ]
    resources :users, only: [] do
      member do
        patch :block
        patch :unblock
      end
    end
  end

  # 홈 화면은 챕터 목록이고, 각 챕터 안에서 게시글을 작성하거나 볼 수 있습니다.
  resources :chapters, only: %i[ index show ] do
    resources :posts, only: %i[ new create ]
  end

  # 게시글, 댓글, 추천/비추천의 일반 사용자 기능입니다.
  resources :comments
  resources :posts, except: %i[ index ] do
    resources :comments, only: %i[ create ]
    resources :post_votes, only: %i[ create ]
  end

  resource :session
  resources :passwords, param: :token

  # 배포 서버가 앱 상태를 확인할 때 쓰는 헬스 체크와 약관 페이지입니다.
  get "up" => "rails/health#show", as: :rails_health_check
  get "terms" => "pages#terms"
  get "privacy" => "pages#privacy"

  root "chapters#index"
end
