// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import lightbox from 'lightbox2/dist/js/lightbox';
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import 'bootstrap'
import "@fortawesome/fontawesome-free/css/all"
import './map'
import 'air-datepicker/dist/js/datepicker'

Rails.start()
ActiveStorage.start()

const images = require.context('../images', true)

window.lightbox = lightbox;

