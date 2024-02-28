import Rails from '@rails/ujs'
import '@hotwired/turbo-rails'
import LocalTime from 'local-time'
import 'controllers'
import 'channels'

Rails.start()
LocalTime.start()