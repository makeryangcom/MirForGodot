import {shallowRef} from "vue";
import {Start, StartNode} from "./node/start";

export const Types = {
    start: shallowRef(Start),
};

export const Nodes = [
    StartNode,
];

export {VueFlow, Panel, useVueFlow} from "@vue-flow/core";
export {Controls, ControlButton} from "@vue-flow/controls";
export {NodeToolbar} from "@vue-flow/node-toolbar";
export {Background} from "@vue-flow/background";
export {MiniMap} from "@vue-flow/minimap";