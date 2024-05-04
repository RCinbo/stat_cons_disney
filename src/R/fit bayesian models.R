test2 <- brm(diff ~ weekend + HOLIDAYPX + WDW_TICKET_SEASON +
              WDWMEANTEMP + inSession + MKPRDDAY + category_code +
              duration + scope_and_scale_code + tod + tod2 + tod3 +
            CapacityLostWGT + (1|land/short_name),
            data = waiting_times_reg,
            family = gaussian(),
            chains = nchains,            # MCMC parameters
            warmup = burnin,
            iter = niter,
            cores = nparallel,
            thin = thinning,
            seed = 123,
            file = find_root_file("data", "model2",
                                  criterion =
                                    has_file(
                                      "stat_cons_disney.Rproj")),
            file_refit = "on_change",
            backend = "cmdstanr")#to

test3 <- brm(diff ~ weekend + YEAR + HOLIDAYPX + WDW_TICKET_SEASON +
               WDWMEANTEMP + inSession + MKPRDDAY + category_code +
               duration + scope_and_scale_code + tod + tod2 + tod3 +
             CapacityLostWGT + (1|short_name),
             data = waiting_times_reg,
             family = gaussian(),
             chains = nchains,            # MCMC parameters
             warmup = burnin,
             iter = niter,
             cores = nparallel,
             thin = thinning,
             seed = 123,
             file = find_root_file("data", "model3",
                                   criterion =
                                     has_file(
                                       "stat_cons_disney.Rproj")),
             file_refit = "on_change",
             backend = "cmdstanr")#to

test4 <- brm(diff ~ weekend + HOLIDAYPX + WDW_TICKET_SEASON +
              WDWMEANTEMP + inSession + MKPRDDAY + category_code +
              duration + scope_and_scale_code + tod + tod2 + tod3 +
            CapacityLostWGT + (1|short_name),
            data = waiting_times_reg,
            family = gaussian(),
            chains = nchains,            # MCMC parameters
            warmup = burnin,
            iter = niter,
            cores = nparallel,
            thin = thinning,
            seed = 123,
            file = find_root_file("data", "model4",
                                  criterion =
                                    has_file(
                                      "stat_cons_disney.Rproj")),
            file_refit = "on_change",
            backend = "cmdstanr")#t
test5 <- brm(diff ~ weekend + as.numeric(YEAR) + HOLIDAYPX + WDW_TICKET_SEASON +
               WDWMEANTEMP + inSession + MKPRDDAY + category_code +
               duration + scope_and_scale_code + tod + tod2 + tod3 +
             CapacityLostWGT + (1|short_name),
             data = waiting_times_reg,
             family = gaussian(),
             chains = nchains,            # MCMC parameters
             warmup = burnin,
             iter = niter,
             cores = nparallel,
             thin = thinning,
             seed = 123,
             file = find_root_file("data", "model5",
                                   criterion =
                                     has_file(
                                       "stat_cons_disney.Rproj")),
             file_refit = "on_change",
             backend = "cmdstanr")#t
