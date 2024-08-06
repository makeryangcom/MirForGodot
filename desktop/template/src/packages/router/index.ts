import {createRouter, createWebHashHistory } from "vue-router";
import Start from "../../pages/start.vue";

const routes: any = [
    {
        path: "/",
        name: "Start",
        component: Start
    }
]

export const Router = createRouter({
    history: createWebHashHistory(),
    routes: routes
});