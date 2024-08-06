import {createApp} from "vue";
import App from "./app.vue";
import {Router} from "./packages/router";
import {Language} from "./packages/language";

const app = createApp(App);

app.use(Router);

app.use(Language);

app.mount("#app");
