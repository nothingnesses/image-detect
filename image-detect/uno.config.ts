import {
    defineConfig,
    presetWind3,
    transformerDirectives,
    transformerVariantGroup,
} from 'unocss'

export default defineConfig({
    content: {
        pipeline: {
            include: [
                // include rs files
                'src/**/*.rs',
            ],
            // exclude files
            exclude: []
            },
        },
    presets: [
        presetWind3(),
    ],
    transformers: [
        transformerDirectives(),
        transformerVariantGroup(),
    ],
})