import { application } from "./application"

import ItemEditController from "./item_edit_controller"
application.register("item-edit", ItemEditController)

import ItemNewController from "./item_new_controller"
application.register("item-new", ItemNewController)

import MenuController from "./menu_controller"
application.register("menu", MenuController)

import RecordEditController from "./record_edit_controller"
application.register("record-edit", RecordEditController)

import RecordNewController from "./record_new_controller"
application.register("record-new", RecordNewController)

import SwiperController from "./swiper_controller"
application.register("swiper", SwiperController)
