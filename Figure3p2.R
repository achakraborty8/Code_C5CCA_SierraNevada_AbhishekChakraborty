library(plotbiomes)
library(ggplot2)
library(readxl)
library(dplyr)
library(cowplot)
library(patchwork)

data(Whittaker_biomes)
whittaker_converted <- Whittaker_biomes
whittaker_converted$temp_c <- (whittaker_converted$temp_c * 9/5) + 32
whittaker_converted$precp_cm <- whittaker_converted$precp_cm * 0.393701

biome_colors <- c(
  "Tundra" = "#C1E1DD",
  "Boreal forest" = "#A5C790",
  "Temperate seasonal forest"= "#97B669",
  "Temperate rain forest" = "#75A95E",
  "Tropical rain forest"= "#317A22",
  "Tropical seasonal forest/savanna" = "#A09700",
  "Subtropical desert" = "#DCBB50",
  "Temperate grassland/desert" = "#FCD57A",
  "Woodland/shrubland" = "#D16E3F"
)

lc_colors <- c(
  "Forest"    = "#396934",
  "Woodland"  = "#1e33eb",
  "Shrub"     = "#de0000",
  "Meadow"    = "#21f4ff"
)

ftt <- 'serif'
ax_t <- 27
lg_t <- 22
ax_tx <- 24
lg_tx <- 20
pnl_t <- 24

data_245 <- read_excel("../data/Whittaker_NEW.xlsx", sheet = "SSP245")
data_370 <- read_excel("../data/Whittaker_NEW.xlsx", sheet = "SSP370")
n_245 <- nrow(data_245)
n_370 <- nrow(data_370)

prepare_lc <- function(dat, n, col_lc, col_precip, col_temp) {
  lc <- tibble::tibble(
    LC_code = dat[4:n, col_lc, drop = TRUE],
    Temperature = as.numeric(dat[4:n, col_temp, drop = TRUE]),
    Precipitation = as.numeric(dat[4:n, col_precip, drop = TRUE])
  )
  lc %>% mutate(description = factor(LC_code, levels = 1:4, labels = c("Forest", "Woodland", "Shrub", "Meadow")))
}

make_panel <- function(lc_data, panel_label, show_x = FALSE, show_y = TRUE) {
  p <- ggplot() +
    geom_polygon(
      data = whittaker_converted,
      aes(x = temp_c, y = precp_cm, group = biome, fill = biome),
      color = "white", linewidth = 0.8
    ) +
    scale_fill_manual(
      values = biome_colors,
      name = "Global Biome",
      breaks = names(biome_colors),
      guide = guide_legend(ncol = 3, title.position = "top", title.hjust = 0.5)
    ) +
    labs(
      x = if (show_x) "Temperature (\u00B0F)" else NULL,
      y = NULL
    ) +
    scale_x_continuous(breaks = seq(0, 90, by = 10), limits = c(0, NA), expand = expansion(mult = c(0.02, 0.08))) +
    scale_y_continuous(breaks = seq(0, 150, by = 50), limits = c(0, 175)) +
    theme_bw() +
    theme(
      text = element_text(family = ftt),
      legend.position = "top",
      legend.box = "vertical",
      legend.margin = margin(0, 0, 0, 0),
      legend.box.margin = margin(0, 0, 5, 0),
      plot.title = element_blank(),
      axis.title = element_text(size = ax_t, face = "bold", family = ftt),
      axis.text = element_text(size = ax_tx, family = ftt),
      legend.title = element_text(size = lg_t, face = "bold", family = ftt),
      legend.text = element_text(size = lg_tx, family = ftt),
      legend.key.size = unit(18, "pt"),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
      legend.key.spacing.x = unit(0, "pt"),
      legend.key.spacing.y = unit(1, "pt"),
    ) +
    geom_point(
      data = lc_data,
      aes(x = Temperature, y = Precipitation, color = description),
      size = 0.5,
      shape = 19,
      stroke = 0.6,
      alpha = 1,
      fill = NA
    ) +
    scale_color_manual(
      values = lc_colors,
      name = "Sierra Nevada Vegetation Type",
      guide = guide_legend(nrow = 1, title.position = "top", title.hjust = 0.5, override.aes = list(size = 4))
    ) +
    annotation_custom(
      grob = grid::textGrob(
        panel_label,
        x = grid::unit(0.01, "npc"),
        y = grid::unit(0.98, "npc"),
        just = c("left", "top"),
        gp = grid::gpar(fontsize = pnl_t, fontface = "bold", fontfamily = ftt)
      ),
      xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf
    )

  return(p)
}

lc_245_present <- prepare_lc(data_245, n_245, 1, 2, 3)
lc_245_mid     <- prepare_lc(data_245, n_245, 6, 7, 8)
lc_245_end     <- prepare_lc(data_245, n_245, 11, 12, 13)

lc_370_present <- prepare_lc(data_370, n_370, 1, 2, 3)
lc_370_mid     <- prepare_lc(data_370, n_370, 6, 7, 8)
lc_370_end     <- prepare_lc(data_370, n_370, 11, 12, 13)


p1_245 <- make_panel(lc_245_present, "(a) Present day",    show_x = FALSE)
p2_245 <- make_panel(lc_245_mid,     "(b) Mid Century",    show_x = FALSE)
p3_245 <- make_panel(lc_245_end,     "(c) End of Century", show_x = TRUE)
p1_370 <- make_panel(lc_370_present, "(d) Present day",    show_x = FALSE)
p2_370 <- make_panel(lc_370_mid,     "(e) Mid Century",    show_x = FALSE)
p3_370 <- make_panel(lc_370_end,     "(f) End of Century", show_x = TRUE)


header_245 <- ggplot() +
  annotate("text", x = 0.5, y = 0.5, label = "SSP 2-4.5",
           size = ax_t / 3, fontface = "bold", family = ftt) +
  theme_void()

header_370 <- ggplot() +
  annotate("text", x = 0.5, y = 0.5, label = "SSP 3-7.0",
           size = ax_t / 3, fontface = "bold", family = ftt) +
  theme_void()

y_label <- wrap_elements(
  grid::textGrob(
    "Precipitation (inches/year)",
    rot = 90,
    gp = grid::gpar(fontsize = ax_t, fontface = "bold", fontfamily = ftt)
  )
)

panel_grid <- (header_245 | header_370) /
              (p1_245 | p1_370) /
              (p2_245 | p2_370) /
              (p3_245 | p3_370) +
  plot_layout(heights = c(0.18, 1, 1, 1), guides = "collect") &
  theme(legend.position = "top",
        legend.box = "vertical",
        legend.justification = "center",
        plot.margin = margin(2, 5, 2, 5))

combined_plot <- y_label | panel_grid
combined_plot <- combined_plot + plot_layout(widths = c(0.03, 1))


ggsave("figure/whittaker_biomes_combined_ssp245_vs_ssp370.png",
       plot = combined_plot, width = 15, height = 10, dpi = 300)
