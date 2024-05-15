class SessionsController < ApplicationController
    def create
        auth = request.env['omniauth.auth']
        # 데이터베이스에 사용자 정보 저장 또는 업데이트
        user = User.find_or_create_by(spotify_id: auth['uid']) do |u|
        u.username = auth['info']['name'] # Spotify 사용자 이름
        u.email = auth['info']['email'] # Spotify 이메일
        u.encrypted_password = SecureRandom.hex(10) # 랜덤 비밀번호 생성
        end

        # Spotify에서 받은 인증 토큰과 만료 시간 저장
        user.update(
        access_token: auth['credentials']['token'],
        refresh_token: auth['credentials']['refresh_token'],
        expires_at: Time.at(auth['credentials']['expires_at'])
        )

        # 세션에 현재 사용자 ID 저장
        session[:user_id] = user.id

        # Spotify 사용자 객체 생성
        spotify_user = RSpotify::User.new(auth)

        redirect_to root_path
    rescue => e
        Rails.logger.error "Spotify OAuth failed: #{e.message}"
        redirect_to login_path, alert: "인증에 실패하였습니다. 다시 시도해주세요."
    end
end
  