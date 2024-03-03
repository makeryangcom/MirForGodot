import { createRouter, createWebHashHistory } from "vue-router";
import StartPage from "../windows/start.vue";

const routes = [
    {
        path: "/",
        name: "Start",
        component: StartPage
    },
];

export const router = createRouter({
    history: createWebHashHistory(),
    routes: routes
})