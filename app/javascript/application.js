// Entry point for the build script in your package.json
//import '@hotwired/turbo-rails'
import { Turbo } from '@hotwired/turbo-rails'
import { Application } from '@hotwired/stimulus'
// Turbo.session.drive = true
import './controllers'

import 'bootstrap'
import 'bootstrap/dist/js/bootstrap.bundle.min'

import { Popper } from '@popperjs/core'

import 'trix'
import '@rails/actiontext'
