import { Application } from "@hotwired/stimulus"
import MenuController from "./menu_controller"
import ItemNewController from "./item_new_controller"
import ItemEditController from "./item_edit_controller"

const application = Application.start()
application.register("menu", MenuController)
application.register("item_new", ItemNewController)
application.register("item_edit", ItemEditController)
