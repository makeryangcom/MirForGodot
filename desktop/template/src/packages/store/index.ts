import { computed } from "vue";
import { useStorage, useDark } from "@vueuse/core";
import { type Theme, themes, type Style, styles } from "../shadcn";

interface Index {
    theme?: Theme["name"]
    radius: number
    style: Style
}

export const RADII = [0, 0.25, 0.5, 0.75, 1];

export function useStore() {
    const isDark = useDark();

    const config = useStorage<Index>("mir2:config", {
        theme: "zinc",
        radius: 0.5,
        style: styles[0].name,
    });

    const themeClass = computed(() => `theme-${config.value.theme}`);
    const theme = computed(() => config.value.theme);
    const radius = computed(() => config.value.radius);
    const style = computed(() => config.value.style);

    function setTheme(themeName: Theme["name"]) {
        config.value.theme = themeName;
    }

    function setRadius(newRadius: number) {
        config.value.radius = newRadius;
    }

    const themePrimary = computed(() => {
        const t = themes.find(t => t.name === theme.value);
        return `hsl(${
            t?.cssVars[isDark ? "dark" : "light"].primary
        })`;
    });

    return {
        RADII,
        config,
        theme,
        setTheme,
        radius,
        setRadius,
        themeClass,
        style,
        themePrimary,
        isDark
    }
}