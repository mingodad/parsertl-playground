//From: https://git.dynare.org/Dynare/preprocessor/-/blob/master/src/DynareBison.yy?ref_type=heads
/*
 * Copyright © 2003-2023 Dynare Team
 *
 * This file is part of Dynare.
 *
 * Dynare is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Dynare is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Dynare.  If not, see <https://www.gnu.org/licenses/>.
 */

/*Tokens*/
%token AIM_SOLVER
%token ANALYTIC_DERIVATION
%token ANALYTIC_DERIVATION_MODE
%token AR
%token POSTERIOR_SAMPLING_METHOD
%token BALANCED_GROWTH_TEST_TOL
%token BAYESIAN_IRF
%token BETA_PDF
%token BLOCK
%token USE_CALIBRATION
%token SILENT_OPTIMIZER
%token BVAR_DENSITY
%token BVAR_FORECAST
%token BVAR_IRF
%token NODECOMPOSITION
%token DR_DISPLAY_TOL
%token HUGE_NUMBER
%token FIG_NAME
%token WRITE_XLS
%token BVAR_PRIOR_DECAY
%token BVAR_PRIOR_FLAT
%token BVAR_PRIOR_LAMBDA
%token INTERACTIVE
%token SCREEN_SHOCKS
%token STEADYSTATE
%token BVAR_PRIOR_MU
%token BVAR_PRIOR_OMEGA
%token BVAR_PRIOR_TAU
%token BVAR_PRIOR_TRAIN
%token DETAIL_PLOT
%token TYPE
%token BVAR_REPLIC
%token BYTECODE
%token ALL_VALUES_REQUIRED
%token PROPOSAL_DISTRIBUTION
%token REALTIME
%token VINTAGE
%token CALIB_SMOOTHER
%token CHANGE_TYPE
%token CHECK
%token CONDITIONAL_FORECAST
%token CONDITIONAL_FORECAST_PATHS
%token CONF_SIG
%token CONSTANT
%token CONTROLLED_VAREXO
%token CORR
%token CUTOFF
%token CYCLE_REDUCTION
%token LOGARITHMIC_REDUCTION
%token COMMA
%token CONSIDER_ALL_ENDOGENOUS
%token CONSIDER_ALL_ENDOGENOUS_AND_AUXILIARY
%token CONSIDER_ONLY_OBSERVED
%token INITIAL_CONDITION_DECOMPOSITION
%token DATAFILE
%token FILE
%token SERIES
%token DOUBLING
%token DR_CYCLE_REDUCTION_TOL
%token DR_LOGARITHMIC_REDUCTION_TOL
%token DR_LOGARITHMIC_REDUCTION_MAXITER
%token DR_ALGO
%token DROP
%token DSAMPLE
%token DYNASAVE
%token DYNATYPE
%token CALIBRATION
%token DIFFERENTIATE_FORWARD_VARS
%token END
%token ENDVAL
%token EQUAL
%token ESTIMATION
%token ESTIMATED_PARAMS
%token ESTIMATED_PARAMS_BOUNDS
%token ESTIMATED_PARAMS_INIT
%token EXTENDED_PATH
%token ENDOGENOUS_PRIOR
%token EXPRESSION
%token FILENAME
%token DIRNAME
%token FILTER_STEP_AHEAD
%token FILTERED_VARS
%token FIRST_OBS
%token FIRST_SIMULATION_PERIOD
%token LAST_SIMULATION_PERIOD
%token LAST_OBS
%token SET_TIME
%token OSR_PARAMS_BOUNDS
%token KEEP_KALMAN_ALGO_IF_SINGULARITY_IS_DETECTED
%token FALSE
%token FLOAT_NUMBER
%token DATES
%token DEFAULT
%token FIXED_POINT
%token FLIP
%token OPT_ALGO
%token COMPILATION_SETUP
%token COMPILER
%token ADD_FLAGS
%token SUBSTITUTE_FLAGS
%token ADD_LIBS
%token SUBSTITUTE_LIBS
%token FORECAST
%token K_ORDER_SOLVER
%token INSTRUMENTS
%token SHIFT
%token MEAN
%token STDEV
%token VARIANCE
%token MODE
%token INTERVAL
%token SHAPE
%token DOMAINN
%token GAMMA_PDF
%token GRAPH
%token GRAPH_FORMAT
%token CONDITIONAL_VARIANCE_DECOMPOSITION
%token NOCHECK
%token STD
%token HISTVAL
%token HISTVAL_FILE
%token HOMOTOPY_SETUP
%token HOMOTOPY_MODE
%token HOMOTOPY_STEPS
%token HOMOTOPY_FORCE_CONTINUE
%token HP_FILTER
%token HP_NGRID
%token FILTERED_THEORETICAL_MOMENTS_GRID
%token HYBRID
%token ONE_SIDED_HP_FILTER
%token IDENTIFICATION
%token INF_CONSTANT
%token INITVAL
%token INITVAL_FILE
%token BOUNDS
%token JSCALE
%token INIT
%token INFILE
%token INVARS
%token INT_NUMBER
%token CONDITIONAL_LIKELIHOOD
%token INV_GAMMA_PDF
%token INV_GAMMA1_PDF
%token INV_GAMMA2_PDF
%token IRF
%token IRF_SHOCKS
%token IRF_PLOT_THRESHOLD
%token IRF_CALIBRATION
%token FAST_KALMAN_FILTER
%token KALMAN_ALGO
%token KALMAN_TOL
%token DIFFUSE_KALMAN_TOL
%token SCHUR_VEC_TOL
%token SUBSAMPLES
%token OPTIONS
%token TOLF
%token TOLX
%token PLOT_INIT_DATE
%token PLOT_END_DATE
%token LAPLACE
%token LIK_ALGO
%token LIK_INIT
%token LINEAR
//%token LINEAR_DECOMPOSITION
%token LOAD_IDENT_FILES
%token LOAD_MH_FILE
%token LOAD_RESULTS_AFTER_LOAD_MH
%token LOAD_PARAMS_AND_STEADY_STATE
%token LOGLINEAR
%token LOGDATA
%token LYAPUNOV
%token LINEAR_APPROXIMATION
%token LYAPUNOV_COMPLEX_THRESHOLD
%token LYAPUNOV_FIXED_POINT_TOL
%token LYAPUNOV_DOUBLING_TOL
%token LOG_DEFLATOR
%token LOG_TREND_VAR
%token LOG_GROWTH_FACTOR
%token MATCHED_MOMENTS
%token MARKOWITZ
%token MARGINAL_DENSITY
%token MAX
%token MAXIT
%token MFS
%token MH_CONF_SIG
%token MH_DROP
%token MH_INIT_SCALE
%token MH_INIT_SCALE_FACTOR
%token MH_JSCALE
%token MH_TUNE_JSCALE
%token MH_TUNE_GUESS
%token MH_POSTERIOR_MODE_ESTIMATION
%token MH_NBLOCKS
%token MH_REPLIC
%token MH_RECOVER
%token MH_INITIALIZE_FROM_PREVIOUS_MCMC
%token MH_INITIALIZE_FROM_PREVIOUS_MCMC_DIRECTORY
%token MH_INITIALIZE_FROM_PREVIOUS_MCMC_RECORD
%token MH_INITIALIZE_FROM_PREVIOUS_MCMC_PRIOR
%token POSTERIOR_MAX_SUBSAMPLE_DRAWS
%token MIN
%token MINIMAL_SOLVING_PERIODS
%token MODE_CHECK
%token MODE_CHECK_NEIGHBOURHOOD_SIZE
%token MODE_CHECK_SYMMETRIC_PLOTS
%token MODE_CHECK_NUMBER_OF_POINTS
%token MODE_COMPUTE
%token MODE_FILE
%token MODEL
%token MODEL_COMPARISON
%token MODEL_INFO
%token MSHOCKS
%token ABS
%token SIGN
%token MODEL_DIAGNOSTICS
%token MODIFIEDHARMONICMEAN
%token MOMENTS_VARENDO
%token CONTEMPORANEOUS_CORRELATION
%token DIFFUSE_FILTER
%token SUB_DRAWS
%token TAPER_STEPS
%token GEWEKE_INTERVAL
%token RAFTERY_LEWIS_QRS
%token RAFTERY_LEWIS_DIAGNOSTICS
%token BROOKS_GELMAN_PLOTROWS
%token MCMC_JUMPING_COVARIANCE
%token MOMENT_CALIBRATION
%token NUMBER_OF_PARTICLES
%token RESAMPLING
%token SYSTEMATIC
%token GENERIC
%token RESAMPLING_THRESHOLD
%token RESAMPLING_METHOD
%token KITAGAWA
%token STRATIFIED
%token SMOOTH
%token CPF_WEIGHTS
%token AMISANOTRISTANI
%token MURRAYJONESPARSLOW
%token WRITE_EQUATION_TAGS
%token FILTER_INITIAL_STATE
%token NONLINEAR_FILTER_INITIALIZATION
%token FILTER_ALGORITHM
%token PROPOSAL_APPROXIMATION
%token CUBATURE
%token UNSCENTED
%token MONTECARLO
%token DISTRIBUTION_APPROXIMATION
%token NAME
%token USE_PENALIZED_OBJECTIVE_FOR_HESSIAN
%token INIT_STATE
%token FAST_REALTIME
%token RESCALE_PREDICTION_ERROR_COVARIANCE
%token GENERATE_IRFS
%token NAN_CONSTANT
%token NO_STATIC
%token NOBS
%token NOCONSTANT
%token NODISPLAY
%token NOCORR
%token NODIAGNOSTIC
%token NOFUNCTIONS
%token NO_HOMOTOPY
%token NOGRAPH
%token POSTERIOR_NOGRAPH
%token POSTERIOR_GRAPH
%token NOMOMENTS
%token NOPRINT
%token NORMAL_PDF
%token SAVE_DRAWS
%token MODEL_NAME
%token STDERR_MULTIPLES
%token DIAGONAL_ONLY
%token DETERMINISTIC_TRENDS
%token OBSERVATION_TRENDS
%token OPTIM
%token OPTIM_WEIGHTS
%token ORDER
%token OSR
%token OSR_PARAMS
%token MAX_DIM_COVA_GROUP
%token ADVANCED
%token OUTFILE
%token OUTVARS
%token OVERWRITE
%token DISCOUNT
%token PARALLEL_LOCAL_FILES
%token PARAMETERS
%token PARAMETER_SET
%token PARTIAL_INFORMATION
%token PERIODS
%token PERIOD
%token PLANNER_OBJECTIVE
%token PLOT_CONDITIONAL_FORECAST
%token PLOT_PRIORS
%token PREFILTER
%token PRESAMPLE
%token PERFECT_FORESIGHT_SETUP
%token PERFECT_FORESIGHT_SOLVER
%token NO_POSTERIOR_KERNEL_DENSITY
%token FUNCTION
%token PERFECT_FORESIGHT_WITH_EXPECTATION_ERRORS_SETUP
%token PERFECT_FORESIGHT_WITH_EXPECTATION_ERRORS_SOLVER
%token PRINT
%token PRIOR_MC
%token PRIOR_TRUNC
%token PRIOR_MODE
%token PRIOR_MEAN
%token POSTERIOR_MODE
%token POSTERIOR_MEAN
%token POSTERIOR_MEDIAN
%token MLE_MODE
%token PRUNING
%token PARTICLE_FILTER_OPTIONS
%token QUOTED_STRING
%token QZ_CRITERIUM
%token QZ_ZERO_THRESHOLD
%token DSGE_VAR
%token DSGE_VARLAG
%token DSGE_PRIOR_WEIGHT
%token TRUNCATE
%token PIPE_E
%token PIPE_X
%token PIPE_P
%token RELATIVE_IRF
%token REPLIC
%token SIMUL_REPLIC
%token RPLOT
%token SAVE_PARAMS_AND_STEADY_STATE
%token PARAMETER_UNCERTAINTY
%token TARGETS
%token SHOCKS
%token HETEROSKEDASTIC_SHOCKS
%token SHOCK_DECOMPOSITION
%token SHOCK_GROUPS
%token USE_SHOCK_GROUPS
%token SIMUL
%token SIMUL_ALGO
%token SIMUL_SEED
%token ENDOGENOUS_TERMINAL_PERIOD
%token SMOOTHER
%token SMOOTHER2HISTVAL
%token SQUARE_ROOT_SOLVER
%token STACK_SOLVE_ALGO
%token STEADY_STATE_MODEL
%token SOLVE_ALGO
%token SOLVER_PERIODS
%token ROBUST_LIN_SOLVE
%token STDERR
%token STEADY
%token STOCH_SIMUL
%token SYLVESTER
%token SYLVESTER_FIXED_POINT_TOL
%token REGIMES
%token REGIME
%token REALTIME_SHOCK_DECOMPOSITION
%token CONDITIONAL
%token UNCONDITIONAL
%token TEX
%token RAMSEY_MODEL
%token RAMSEY_POLICY
%token RAMSEY_CONSTRAINTS
%token PLANNER_DISCOUNT
%token PLANNER_DISCOUNT_LATEX_NAME
%token DISCRETIONARY_POLICY
%token DISCRETIONARY_TOL
%token EVALUATE_PLANNER_OBJECTIVE
%token OCCBIN_SETUP
%token OCCBIN_SOLVER
%token OCCBIN_WRITE_REGIMES
%token OCCBIN_GRAPH
%token SIMUL_MAXIT
%token LIKELIHOOD_MAXIT
%token SMOOTHER_MAXIT
%token SIMUL_PERIODS
%token LIKELIHOOD_PERIODS
%token SMOOTHER_PERIODS
%token SIMUL_CURB_RETRENCH
%token LIKELIHOOD_CURB_RETRENCH
%token SMOOTHER_CURB_RETRENCH
%token SIMUL_CHECK_AHEAD_PERIODS
%token SIMUL_MAX_CHECK_AHEAD_PERIODS
%token SIMUL_RESET_CHECK_AHEAD_PERIODS
%token LIKELIHOOD_CHECK_AHEAD_PERIODS
%token LIKELIHOOD_MAX_CHECK_AHEAD_PERIODS
%token SMOOTHER_CHECK_AHEAD_PERIODS
%token SMOOTHER_MAX_CHECK_AHEAD_PERIODS
%token SIMUL_DEBUG
%token SMOOTHER_DEBUG
%token SIMUL_PERIODIC_SOLUTION
%token LIKELIHOOD_PERIODIC_SOLUTION
%token SMOOTHER_PERIODIC_SOLUTION
%token LIKELIHOOD_INVERSION_FILTER
%token SMOOTHER_INVERSION_FILTER
%token FILTER_USE_RELEXATION
%token LIKELIHOOD_PIECEWISE_KALMAN_FILTER
%token SMOOTHER_PIECEWISE_KALMAN_FILTER
%token LIKELIHOOD_MAX_KALMAN_ITERATIONS
%token TEX_NAME
%token TRUE
%token BIND
%token RELAX
%token ERROR_BIND
%token ERROR_RELAX
%token UNIFORM_PDF
%token UNIT_ROOT_VARS
%token USE_DLL
%token USEAUTOCORR
%token GSA_SAMPLE_FILE
%token USE_UNIVARIATE_FILTERS_IF_SINGULARITY_IS_DETECTED
%token VALUES
%token SCALES
%token VAR
%token VAREXO
%token VAREXO_DET
%token VARIABLE
%token VAROBS
%token VAREXOBS
%token PREDETERMINED_VARIABLES
%token VAR_EXPECTATION
%token VAR_EXPECTATION_MODEL
%token PLOT_SHOCK_DECOMPOSITION
%token MODEL_LOCAL_VARIABLE
%token WRITE_LATEX_DYNAMIC_MODEL
%token WRITE_LATEX_STATIC_MODEL
%token WRITE_LATEX_ORIGINAL_MODEL
%token WRITE_LATEX_STEADY_STATE_MODEL
%token XLS_SHEET
%token XLS_RANGE
%token LMMCP
%token BANDPASS_FILTER
%token COLORMAP
%token VAR_MODEL
%token PAC_MODEL
%token QOQ
%token YOY
%token AOA
%token PAC_EXPECTATION
%token TREND_COMPONENT_MODEL
%token EQUAL_EQUAL
%token EXCLAMATION_EQUAL
%token LESS
%token GREATER
%token LESS_EQUAL
%token GREATER_EQUAL
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token UNARY
%token POWER
%token EXP
%token LOG
%token LN
%token LOG10
%token SIN
%token COS
%token TAN
%token ASIN
%token ACOS
%token ATAN
%token SINH
%token COSH
%token TANH
%token ASINH
%token ACOSH
%token ATANH
%token ERF
%token ERFC
%token DIFF
%token ADL
%token AUXILIARY_MODEL_NAME
%token SQRT
%token CBRT
%token NORMCDF
%token NORMPDF
%token STEADY_STATE
%token EXPECTATION
%token DYNARE_SENSITIVITY
%token MORRIS
%token STAB
%token REDFORM
%token PPRIOR
%token PRIOR_RANGE
%token PPOST
%token ILPTAU
%token MORRIS_NLIV
%token MORRIS_NTRA
%token NSAM
%token LOAD_REDFORM
%token LOAD_RMSE
%token LOAD_STAB
%token ALPHA2_STAB
%token LOGTRANS_REDFORM
%token THRESHOLD_REDFORM
%token KSSTAT_REDFORM
%token ALPHA2_REDFORM
%token NAMENDO
%token NAMLAGENDO
%token NAMEXO
%token RMSE
%token LIK_ONLY
%token VAR_RMSE
%token PFILT_RMSE
%token ISTART_RMSE
%token ALPHA_RMSE
%token ALPHA2_RMSE
%token FREQ
%token INITIAL_YEAR
%token INITIAL_SUBPERIOD
%token FINAL_YEAR
%token FINAL_SUBPERIOD
%token DATA
%token VLIST
%token VLISTLOG
%token VLISTPER
%token SPECTRAL_DENSITY
%token INIT2SHOCKS
%token RESTRICTION
%token RESTRICTION_FNAME
%token CROSS_RESTRICTIONS
%token NLAGS
%token CONTEMP_REDUCED_FORM
%token REAL_PSEUDO_FORECAST
%token DUMMY_OBS
%token NSTATES
%token INDXSCALESSTATES
%token NO_BAYESIAN_PRIOR
%token SPECIFICATION
%token SIMS_ZHA
%token ALPHA
%token BETA
%token ABAND
%token NINV
%token CMS
%token NCMS
%token CNUM
%token GAMMA
%token INV_GAMMA
%token INV_GAMMA1
%token INV_GAMMA2
%token NORMAL
%token UNIFORM
%token EPS
%token PDF
%token FIG
%token DR
%token NONE
%token PRIOR
%token PRIOR_VARIANCE
%token HESSIAN
%token IDENTITY_MATRIX
%token DIRICHLET
//%token DIAGONAL
//%token OPTIMAL
%token GSIG2_LMDM
%token Q_DIAG
%token FLAT_PRIOR
%token NCSK
%token NSTD
%token WEIBULL
%token WEIBULL_PDF
%token GMM
%token SMM
%token INDXPARR
%token INDXOVR
%token INDXAP
%token APBAND
%token INDXIMF
%token INDXFORE
%token FOREBAND
%token INDXGFOREHAT
%token INDXGIMFHAT
%token INDXESTIMA
%token INDXGDLS
%token EQ_MS
%token FILTER_COVARIANCE
%token UPDATED_COVARIANCE
%token FILTER_DECOMPOSITION
%token SMOOTHED_STATE_UNCERTAINTY
%token SMOOTHER_REDUX
%token EQ_CMS
%token TLINDX
%token TLNUMBER
%token RESTRICTIONS
%token POSTERIOR_SAMPLER_OPTIONS
%token OUTPUT_FILE_TAG
%token HORIZON
%token SBVAR
%token TREND_VAR
%token DEFLATOR
%token GROWTH_FACTOR
%token MS_IRF
%token MS_VARIANCE_DECOMPOSITION
%token GROWTH
%token MS_ESTIMATION
%token MS_SIMULATION
%token MS_COMPUTE_MDD
%token MS_COMPUTE_PROBABILITIES
%token MS_FORECAST
%token SVAR_IDENTIFICATION
%token EQUATION
%token EXCLUSION
%token LAG
%token UPPER_CHOLESKY
%token LOWER_CHOLESKY
%token MONTHLY
%token QUARTERLY
%token MARKOV_SWITCHING
%token CHAIN
%token DURATION
%token NUMBER_OF_REGIMES
%token NUMBER_OF_LAGS
%token EPILOGUE
%token SVAR
%token SVAR_GLOBAL_IDENTIFICATION_CHECK
%token COEFF
%token COEFFICIENTS
%token VARIANCES
%token CONSTANTS
%token EQUATIONS
%token EXTERNAL_FUNCTION
%token EXT_FUNC_NAME
%token EXT_FUNC_NARGS
%token FIRST_DERIV_PROVIDED
%token SECOND_DERIV_PROVIDED
%token SELECTED_VARIABLES_ONLY
%token COVA_COMPUTE
%token SIMULATION_FILE_TAG
%token FILE_TAG
%token NO_ERROR_BANDS
%token ERROR_BAND_PERCENTILES
%token SHOCKS_PER_PARAMETER
%token NO_CREATE_INIT
%token SHOCK_DRAWS
%token FREE_PARAMETERS
%token MEDIAN
%token DATA_OBS_NBR
%token NEIGHBORHOOD_WIDTH
%token PVALUE_KS
%token PVALUE_CORR
%token FILTERED_PROBABILITIES
%token REAL_TIME_SMOOTHED
%token PRIOR_FUNCTION
%token POSTERIOR_FUNCTION
%token SAMPLING_DRAWS
%token PROPOSAL_TYPE
%token PROPOSAL_UPPER_BOUND
%token PROPOSAL_LOWER_BOUND
%token PROPOSAL_DRAWS
%token USE_MEAN_CENTER
%token ADAPTIVE_MH_DRAWS
%token THINNING_FACTOR
%token COEFFICIENTS_PRIOR_HYPERPARAMETERS
%token CONVERGENCE_STARTING_VALUE
%token CONVERGENCE_ENDING_VALUE
%token CONVERGENCE_INCREMENT_VALUE
%token MAX_ITERATIONS_STARTING_VALUE
%token MAX_ITERATIONS_INCREMENT_VALUE
%token MAX_BLOCK_ITERATIONS
%token MAX_REPEATED_OPTIMIZATION_RUNS
%token FUNCTION_CONVERGENCE_CRITERION
%token SAVE_REALTIME
%token PARAMETER_CONVERGENCE_CRITERION
%token NUMBER_OF_LARGE_PERTURBATIONS
%token NUMBER_OF_SMALL_PERTURBATIONS
%token NUMBER_OF_POSTERIOR_DRAWS_AFTER_PERTURBATION
%token MAX_NUMBER_OF_STAGES
%token RANDOM_FUNCTION_CONVERGENCE_CRITERION
%token RANDOM_PARAMETER_CONVERGENCE_CRITERION
%token NO_INIT_ESTIMATION_CHECK_FIRST_OBS
%token HETEROSKEDASTIC_FILTER
%token TIME_SHIFT
%token STRUCTURAL
%token CONSTANT_SIMULATION_LENGTH
%token SURPRISE
%token OCCBIN_CONSTRAINTS
%token PAC_TARGET_INFO
%token COMPONENT
%token TARGET
%token AUXNAME
%token AUXNAME_TARGET_NONSTATIONARY
%token PAC_TARGET_NONSTATIONARY
%token KIND
%token LL
%token DL
%token DD
%token ADD
%token MULTIPLY
%token METHOD_OF_MOMENTS
%token MOM_METHOD
%token BARTLETT_KERNEL_LAG
%token WEIGHTING_MATRIX
%token WEIGHTING_MATRIX_SCALING_FACTOR
%token ANALYTIC_STANDARD_ERRORS
%token ANALYTIC_JACOBIAN
%token PENALIZED_ESTIMATOR
%token VERBOSE
%token SIMULATION_MULTIPLE
//%token MOM_SEED
%token SEED
%token BOUNDED_SHOCK_SUPPORT
%token ADDITIONAL_OPTIMIZER_STEPS
//%token MOM_SE_TOLX
%token SE_TOLX
//%token MOM_BURNIN
%token BURNIN
%token EQTAGS
%token ANALYTICAL_GIRF
%token IRF_IN_PERCENT
%token EMAS_GIRF
%token EMAS_DROP
%token EMAS_TOLF
%token EMAS_MAX_ITER
%token NO_IDENTIFICATION_STRENGTH
%token NO_IDENTIFICATION_REDUCEDFORM
%token NO_IDENTIFICATION_MOMENTS
%token NO_IDENTIFICATION_MINIMAL
%token NO_IDENTIFICATION_SPECTRUM
%token NORMALIZE_JACOBIANS
%token GRID_NBR
%token TOL_RANK
%token TOL_DERIV
%token TOL_SV
%token CHECKS_VIA_SUBSETS
%token MAX_DIM_SUBSETS_GROUPS
%token ZERO_MOMENTS_TOLERANCE
%token MAX_NROWS
%token SQUEEZE_SHOCK_DECOMPOSITION
%token WITH_EPILOGUE
%token MODEL_REMOVE
%token MODEL_REPLACE
%token MODEL_OPTIONS
%token VAR_REMOVE
%token ESTIMATED_PARAMS_REMOVE
%token BLOCK_STATIC
%token BLOCK_DYNAMIC
%token INCIDENCE
%token RESID
%token NON_ZERO
%token LEARNT_IN
%token PLUS_EQUAL
%token TIMES_EQUAL
%token FSOLVE_OPTIONS
%token ENDVAL_STEADY
%token STEADY_SOLVE_ALGO
%token STEADY_MAXIT
%token STEADY_TOLF
%token STEADY_TOLX
%token STEADY_MARKOWITZ
%token HOMOTOPY_MAX_COMPLETION_SHARE
%token HOMOTOPY_MIN_STEP_SIZE
%token HOMOTOPY_INITIAL_STEP_SIZE
%token HOMOTOPY_STEP_SIZE_INCREASE_SUCCESS_COUNT
%token HOMOTOPY_LINEARIZATION_FALLBACK
%token HOMOTOPY_MARGINAL_LINEARIZATION_FALLBACK
%token SYMBOL_VEC
%token ';'
%token ':'
%token '('
%token ')'
%token '['
%token ']'
%token '#'
%token '.'

%left /*1*/ EQUAL_EQUAL EXCLAMATION_EQUAL
%left /*2*/ LESS GREATER LESS_EQUAL GREATER_EQUAL
%left /*3*/ PLUS MINUS
%left /*4*/ TIMES DIVIDE
%precedence /*5*/ UNARY
%nonassoc /*6*/ POWER

%start statement_list

%%

statement_list :
	statement
	| statement_list statement
	;

statement :
	parameters
	| var
	| varexo
	| varexo_det
	| predetermined_variables
	| model_local_variable
	| change_type
	| model
	| initval
	| initval_file
	| endval
	| histval
	| init_param
	| shocks
	| mshocks
	| heteroskedastic_shocks
	| steady
	| check
	| simul
	| stoch_simul
	| estimation
	| estimated_params
	| estimated_params_bounds
	| estimated_params_init
	| estimated_params_remove
	| set_time
	| data
	| epilogue
	| var_model
	| pac_model
	| trend_component_model
	| prior
	| prior_eq
	| subsamples
	| subsamples_eq
	| options
	| options_eq
	| varobs
	| deterministic_trends
	| observation_trends
	| filter_initial_state
	| varexobs
	| unit_root_vars
	| dsample
	| rplot
	| optim_weights
	| osr_params
	| osr_params_bounds
	| osr
	| dynatype
	| dynasave
	| model_comparison
	| model_info
	| planner_objective
	| ramsey_model
	| ramsey_policy
	| ramsey_constraints
	| evaluate_planner_objective
	| occbin_setup
	| occbin_solver
	| occbin_write_regimes
	| occbin_graph
	| discretionary_policy
	| bvar_density
	| bvar_forecast
	| bvar_irf
	| sbvar
	| dynare_sensitivity
	| homotopy_setup
	| forecast
	| load_params_and_steady_state
	| save_params_and_steady_state
	| identification
	| write_latex_dynamic_model
	| write_latex_static_model
	| write_latex_original_model
	| write_latex_steady_state_model
	| shock_decomposition
	| realtime_shock_decomposition
	| plot_shock_decomposition
	| initial_condition_decomposition
	| squeeze_shock_decomposition
	| conditional_forecast
	| conditional_forecast_paths
	| plot_conditional_forecast
	| svar_identification
	| svar_global_identification_check
	| markov_switching
	| svar
	| external_function
	| steady_state_model
	| trend_var
	| generate_irfs
	| log_trend_var
	| ms_estimation
	| ms_simulation
	| ms_compute_mdd
	| ms_compute_probabilities
	| ms_forecast
	| ms_irf
	| ms_variance_decomposition
	| calib_smoother
	| extended_path
	| model_diagnostics
	| moment_calibration
	| irf_calibration
	| smoother2histval
	| histval_file
	| perfect_foresight_setup
	| perfect_foresight_solver
	| perfect_foresight_with_expectation_errors_setup
	| perfect_foresight_with_expectation_errors_solver
	| prior_function
	| posterior_function
	| method_of_moments
	| shock_groups
	| init2shocks
	| var_expectation_model
	| compilation_setup
	| matched_moments
	| occbin_constraints
	| model_remove
	| model_replace
	| model_options
	| var_remove
	| pac_target_info
	| resid
	;

dsample :
	DSAMPLE INT_NUMBER ';'
	| DSAMPLE INT_NUMBER INT_NUMBER ';'
	;

symbol_list :
	symbol_list symbol
	| symbol_list COMMA symbol
	| symbol
	;

symbol_list_or_wildcard :
	symbol_list
	| ':'
	;

symbol_list_with_tex :
	symbol_list_with_tex symbol
	| symbol_list_with_tex COMMA symbol
	| symbol
	| symbol_list_with_tex symbol TEX_NAME
	| symbol_list_with_tex COMMA symbol TEX_NAME
	| symbol TEX_NAME
	;

partition_elem :
	symbol EQUAL QUOTED_STRING
	;

partition_1 :
	'(' partition_elem
	| '(' COMMA partition_elem
	| partition_1 partition_elem
	| partition_1 COMMA partition_elem
	;

partition :
	partition_1 ')'
	| partition_1 COMMA ')'
	;

symbol_list_with_tex_and_partition :
	symbol_list_with_tex_and_partition symbol
	| symbol_list_with_tex_and_partition COMMA symbol
	| symbol
	| symbol_list_with_tex_and_partition symbol partition
	| symbol_list_with_tex_and_partition COMMA symbol partition
	| symbol partition
	| symbol_list_with_tex_and_partition symbol TEX_NAME
	| symbol_list_with_tex_and_partition COMMA symbol TEX_NAME
	| symbol TEX_NAME
	| symbol_list_with_tex_and_partition symbol TEX_NAME partition
	| symbol_list_with_tex_and_partition COMMA symbol TEX_NAME partition
	| symbol TEX_NAME partition
	;

rplot :
	RPLOT symbol_list ';'
	;

trend_var :
	TREND_VAR '(' GROWTH_FACTOR EQUAL hand_side ')' symbol_list_with_tex ';'
	;

log_trend_var :
	LOG_TREND_VAR '(' LOG_GROWTH_FACTOR EQUAL hand_side ')' symbol_list_with_tex ';'
	;

var :
	VAR symbol_list_with_tex_and_partition ';'
	| VAR '(' LOG ')' symbol_list_with_tex_and_partition ';'
	| VAR '(' DEFLATOR EQUAL hand_side ')' symbol_list_with_tex_and_partition ';'
	| VAR '(' LOG COMMA DEFLATOR EQUAL hand_side ')' symbol_list_with_tex_and_partition ';'
	| VAR '(' LOG_DEFLATOR EQUAL hand_side ')' symbol_list_with_tex_and_partition ';'
	;

var_remove :
	VAR_REMOVE symbol_list ';'
	;

var_model :
	VAR_MODEL '(' var_model_options_list ')' ';'
	;

var_model_options_list :
	var_model_options_list COMMA var_model_options
	| var_model_options
	;

var_model_options :
	o_var_name
	| o_var_eq_tags
	| o_var_structural
	;

trend_component_model :
	TREND_COMPONENT_MODEL '(' trend_component_model_options_list ')' ';'
	;

trend_component_model_options_list :
	trend_component_model_options_list COMMA trend_component_model_options
	| trend_component_model_options
	;

trend_component_model_options :
	o_trend_component_model_name
	| o_trend_component_model_targets
	| o_trend_component_model_eq_tags
	;

pac_model :
	PAC_MODEL '(' pac_model_options_list ')' ';'
	;

pac_model_options_list :
	pac_model_options_list COMMA pac_model_options
	| pac_model_options
	;

pac_model_options :
	o_pac_name
	| o_pac_aux_model_name
	| o_pac_discount
	| o_pac_growth
	| o_pac_auxname
	| o_pac_kind
	;

var_expectation_model :
	VAR_EXPECTATION_MODEL '(' var_expectation_model_options_list ')' ';'
	;

var_expectation_model_options_list :
	var_expectation_model_option
	| var_expectation_model_options_list COMMA var_expectation_model_option
	;

var_expectation_model_option :
	VARIABLE EQUAL symbol
	| EXPRESSION EQUAL hand_side
	| AUXILIARY_MODEL_NAME EQUAL symbol
	| HORIZON EQUAL INT_NUMBER
	| HORIZON EQUAL integer_range_w_inf
	| MODEL_NAME EQUAL symbol
	| DISCOUNT EQUAL expression
	| TIME_SHIFT EQUAL signed_integer
	;

varexo :
	VAREXO symbol_list_with_tex_and_partition ';'
	;

varexo_det :
	VAREXO_DET symbol_list_with_tex_and_partition ';'
	;

predetermined_variables :
	PREDETERMINED_VARIABLES symbol_list ';'
	;

parameters :
	PARAMETERS symbol_list_with_tex_and_partition ';'
	;

model_local_variable :
	MODEL_LOCAL_VARIABLE symbol_list_with_tex ';'
	;

change_type :
	CHANGE_TYPE '(' change_type_arg ')' symbol_list ';'
	;

change_type_arg :
	PARAMETERS
	| VAR
	| VAREXO
	| VAREXO_DET
	;

init_param :
	symbol EQUAL expression ';'
	;

expression :
	'(' expression ')'
	| namespace_qualified_symbol
	| non_negative_number
	| expression PLUS /*3L*/ expression
	| expression MINUS /*3L*/ expression
	| expression DIVIDE /*4L*/ expression
	| expression TIMES /*4L*/ expression
	| expression POWER /*6N*/ expression
	| expression LESS /*2L*/ expression
	| expression GREATER /*2L*/ expression
	| expression LESS_EQUAL /*2L*/ expression
	| expression GREATER_EQUAL /*2L*/ expression
	| expression EQUAL_EQUAL /*1L*/ expression
	| expression EXCLAMATION_EQUAL /*1L*/ expression
	| MINUS /*3L*/ expression %prec UNARY /*5P*/
	| PLUS /*3L*/ expression %prec UNARY /*5P*/
	| EXP '(' expression ')'
	| LOG '(' expression ')'
	| LN '(' expression ')'
	| LOG10 '(' expression ')'
	| SIN '(' expression ')'
	| COS '(' expression ')'
	| TAN '(' expression ')'
	| ASIN '(' expression ')'
	| ACOS '(' expression ')'
	| ATAN '(' expression ')'
	| SINH '(' expression ')'
	| COSH '(' expression ')'
	| TANH '(' expression ')'
	| ASINH '(' expression ')'
	| ACOSH '(' expression ')'
	| ATANH '(' expression ')'
	| SQRT '(' expression ')'
	| CBRT '(' expression ')'
	| ABS '(' expression ')'
	| SIGN '(' expression ')'
	| MAX '(' expression COMMA expression ')'
	| MIN '(' expression COMMA expression ')'
	| namespace_qualified_symbol '(' comma_expression ')'
	| NORMCDF '(' expression COMMA expression COMMA expression ')'
	| NORMCDF '(' expression ')'
	| NORMPDF '(' expression COMMA expression COMMA expression ')'
	| NORMPDF '(' expression ')'
	| ERF '(' expression ')'
	| ERFC '(' expression ')'
	| NAN_CONSTANT
	| INF_CONSTANT
	;

comma_expression :
	expression
	| comma_expression COMMA expression
	;

expression_or_empty :
	/*empty*/
	| expression
	;

initval :
	INITVAL ';' initval_list END ';'
	| INITVAL '(' ALL_VALUES_REQUIRED ')' ';' initval_list END ';'
	;

initval_list :
	initval_list initval_elem
	| initval_elem
	;

initval_elem :
	symbol EQUAL expression ';'
	;

histval_file :
	HISTVAL_FILE '(' h_options_list ')' ';'
	;

initval_file :
	INITVAL_FILE '(' h_options_list ')' ';'
	;

h_options_list :
	h_options_list COMMA h_options
	| h_options
	;

h_options :
	o_filename
	| o_datafile
	| o_first_obs
	| o_data_first_obs
	| o_first_simulation_period
	| o_date_first_simulation_period
	| o_last_simulation_period
	| o_date_last_simulation_period
	| o_last_obs
	| o_data_last_obs
	| o_nobs
	| o_series
	;

endval :
	ENDVAL ';' endval_list END ';'
	| ENDVAL '(' ALL_VALUES_REQUIRED ')' ';' endval_list END ';'
	| ENDVAL '(' LEARNT_IN EQUAL INT_NUMBER ')' ';' endval_list END ';'
	;

endval_list :
	endval_list endval_elem
	| endval_elem
	;

endval_elem :
	symbol EQUAL expression ';'
	| symbol PLUS_EQUAL expression ';'
	| symbol TIMES_EQUAL expression ';'
	;

histval :
	HISTVAL ';' histval_list END ';'
	| HISTVAL '(' ALL_VALUES_REQUIRED ')' ';' histval_list END ';'
	;

histval_list :
	histval_list histval_elem
	| histval_elem
	;

histval_elem :
	symbol '(' signed_integer ')' EQUAL expression ';'
	;

epilogue :
	EPILOGUE ';' epilogue_equation_list END ';'
	;

epilogue_equation_list :
	epilogue_equation_list epilogue_equation
	| epilogue_equation
	;

epilogue_equation :
	NAME EQUAL expression ';'
	;

compilation_setup :
	COMPILATION_SETUP '(' compilation_setup_options_list ')' ';'
	;

compilation_setup_options_list :
	compilation_setup_options_list COMMA compilation_setup_option
	| compilation_setup_option
	;

compilation_setup_option :
	SUBSTITUTE_FLAGS EQUAL QUOTED_STRING
	| ADD_FLAGS EQUAL QUOTED_STRING
	| SUBSTITUTE_LIBS EQUAL QUOTED_STRING
	| ADD_LIBS EQUAL QUOTED_STRING
	| COMPILER EQUAL QUOTED_STRING
	;

matched_moments :
	MATCHED_MOMENTS ';' matched_moments_list END ';'
	;

matched_moments_list :
	hand_side ';'
	| matched_moments_list hand_side ';'
	;

occbin_constraints :
	OCCBIN_CONSTRAINTS ';' occbin_constraints_regimes_list END ';'
	;

occbin_constraints_regimes_list :
	occbin_constraints_regime
	| occbin_constraints_regimes_list occbin_constraints_regime
	;

occbin_constraints_regime :
	NAME QUOTED_STRING ';' occbin_constraints_regime_options_list
	;

occbin_constraints_regime_options_list :
	occbin_constraints_regime_option
	| occbin_constraints_regime_options_list occbin_constraints_regime_option
	;

occbin_constraints_regime_option :
	BIND hand_side ';'
	| RELAX hand_side ';'
	| ERROR_BIND hand_side ';'
	| ERROR_RELAX hand_side ';'
	;

pac_target_info :
	PAC_TARGET_INFO '(' symbol ')' ';' pac_target_info_statement_list END ';'
	;

pac_target_info_statement_list :
	pac_target_info_statement
	| pac_target_info_statement_list pac_target_info_statement
	;

pac_target_info_statement :
	TARGET hand_side ';'
	| AUXNAME_TARGET_NONSTATIONARY symbol ';'
	| pac_target_info_component
	;

pac_target_info_component :
	COMPONENT hand_side ';' pac_target_info_component_list
	;

pac_target_info_component_list :
	pac_target_info_component_elem
	| pac_target_info_component_list pac_target_info_component_elem
	;

pac_target_info_component_elem :
	GROWTH hand_side ';'
	| AUXNAME symbol ';'
	| KIND pac_target_kind ';'
	;

pac_target_kind :
	LL
	| DL
	| DD
	;

resid :
	RESID ';'
	| RESID '(' o_non_zero ')' ';'
	;

model_option :
	BLOCK
	| o_cutoff
	| o_mfs
	| BYTECODE
	| USE_DLL
	| NO_STATIC
	| DIFFERENTIATE_FORWARD_VARS
	| DIFFERENTIATE_FORWARD_VARS EQUAL '(' symbol_list ')'
	| o_linear
	| PARALLEL_LOCAL_FILES EQUAL '(' parallel_local_filename_list ')'
	| BALANCED_GROWTH_TEST_TOL EQUAL non_negative_number
	;

model_options_list :
	model_options_list COMMA model_option
	| model_option
	;

model :
	MODEL ';' equation_list END ';'
	| MODEL '(' model_options_list ')' ';' equation_list END ';'
	;

equation_list :
	equation_list equation
	| equation_list pound_expression
	| equation
	| pound_expression
	;

equation :
	hand_side EQUAL hand_side ';'
	| hand_side ';'
	| '[' tags_list ']' hand_side EQUAL hand_side ';'
	| '[' tags_list ']' hand_side ';'
	;

tags_list :
	tags_list COMMA tag_pair
	| tag_pair
	;

tag_pair :
	symbol EQUAL QUOTED_STRING
	| symbol
	;

hand_side :
	'(' hand_side ')'
	| namespace_qualified_symbol
	| symbol PIPE_E
	| symbol PIPE_X
	| symbol PIPE_P
	| non_negative_number
	| hand_side PLUS /*3L*/ hand_side
	| hand_side MINUS /*3L*/ hand_side
	| hand_side DIVIDE /*4L*/ hand_side
	| hand_side TIMES /*4L*/ hand_side
	| hand_side LESS /*2L*/ hand_side
	| hand_side GREATER /*2L*/ hand_side
	| hand_side LESS_EQUAL /*2L*/ hand_side
	| hand_side GREATER_EQUAL /*2L*/ hand_side
	| hand_side EQUAL_EQUAL /*1L*/ hand_side
	| hand_side EXCLAMATION_EQUAL /*1L*/ hand_side
	| hand_side POWER /*6N*/ hand_side
	| EXPECTATION '(' signed_integer ')' '(' hand_side ')'
	| VAR_EXPECTATION '(' symbol ')'
	| PAC_EXPECTATION '(' symbol ')'
	| PAC_TARGET_NONSTATIONARY '(' symbol ')'
	| MINUS /*3L*/ hand_side %prec UNARY /*5P*/
	| PLUS /*3L*/ hand_side %prec UNARY /*5P*/
	| EXP '(' hand_side ')'
	| DIFF '(' hand_side ')'
	| ADL '(' hand_side COMMA QUOTED_STRING ')'
	| ADL '(' hand_side COMMA QUOTED_STRING COMMA INT_NUMBER ')'
	| ADL '(' hand_side COMMA QUOTED_STRING COMMA vec_int ')'
	| LOG '(' hand_side ')'
	| LN '(' hand_side ')'
	| LOG10 '(' hand_side ')'
	| SIN '(' hand_side ')'
	| COS '(' hand_side ')'
	| TAN '(' hand_side ')'
	| ASIN '(' hand_side ')'
	| ACOS '(' hand_side ')'
	| ATAN '(' hand_side ')'
	| SINH '(' hand_side ')'
	| COSH '(' hand_side ')'
	| TANH '(' hand_side ')'
	| ASINH '(' hand_side ')'
	| ACOSH '(' hand_side ')'
	| ATANH '(' hand_side ')'
	| SQRT '(' hand_side ')'
	| CBRT '(' hand_side ')'
	| ABS '(' hand_side ')'
	| SIGN '(' hand_side ')'
	| MAX '(' hand_side COMMA hand_side ')'
	| MIN '(' hand_side COMMA hand_side ')'
	| namespace_qualified_symbol '(' comma_hand_side ')'
	| NORMCDF '(' hand_side COMMA hand_side COMMA hand_side ')'
	| NORMCDF '(' hand_side ')'
	| NORMPDF '(' hand_side COMMA hand_side COMMA hand_side ')'
	| NORMPDF '(' hand_side ')'
	| ERF '(' hand_side ')'
	| ERFC '(' hand_side ')'
	| STEADY_STATE '(' hand_side ')'
	;

comma_hand_side :
	hand_side
	| comma_hand_side COMMA hand_side
	;

pound_expression :
	'#' symbol EQUAL hand_side ';'
	;

model_remove :
	MODEL_REMOVE '(' tag_pair_list_for_selection ')' ';'
	;

model_replace :
	MODEL_REPLACE '(' tag_pair_list_for_selection ')' ';' equation_list END ';'
	;

model_options :
	MODEL_OPTIONS '(' model_options_list ')' ';'
	;

tag_pair_list_for_selection :
	QUOTED_STRING
	| symbol EQUAL QUOTED_STRING
	| tag_pair_list_for_selection COMMA QUOTED_STRING
	| tag_pair_list_for_selection COMMA symbol EQUAL QUOTED_STRING
	;

shocks :
	SHOCKS ';' shock_list END ';'
	| SHOCKS '(' OVERWRITE ')' ';' shock_list END ';'
	| SHOCKS '(' OVERWRITE ')' ';' END ';'
	| SHOCKS '(' SURPRISE ')' ';' det_shock_list END ';'
	| SHOCKS '(' SURPRISE COMMA OVERWRITE ')' ';' det_shock_list END ';'
	| SHOCKS '(' OVERWRITE COMMA SURPRISE ')' ';' det_shock_list END ';'
	| SHOCKS '(' LEARNT_IN EQUAL INT_NUMBER ')' ';' det_shock_list END ';'
	| SHOCKS '(' LEARNT_IN EQUAL INT_NUMBER COMMA OVERWRITE ')' ';' det_shock_list END ';'
	| SHOCKS '(' OVERWRITE COMMA LEARNT_IN EQUAL INT_NUMBER ')' ';' det_shock_list END ';'
	;

shock_list :
	shock_list shock_elem
	| shock_elem
	;

shock_elem :
	det_shock_elem
	| VAR symbol ';' STDERR expression ';'
	| VAR symbol EQUAL expression ';'
	| VAR symbol COMMA symbol EQUAL expression ';'
	| CORR symbol COMMA symbol EQUAL expression ';'
	;

det_shock_elem :
	VAR symbol ';' PERIODS period_list ';' VALUES value_list ';'
	| VAR symbol ';' PERIODS period_list ';' ADD value_list ';'
	| VAR symbol ';' PERIODS period_list ';' MULTIPLY value_list ';'
	;

det_shock_list :
	det_shock_list det_shock_elem
	| det_shock_elem
	;

heteroskedastic_shocks :
	HETEROSKEDASTIC_SHOCKS ';' heteroskedastic_shock_list END ';'
	| HETEROSKEDASTIC_SHOCKS '(' OVERWRITE ')' ';' heteroskedastic_shock_list END ';'
	| HETEROSKEDASTIC_SHOCKS '(' OVERWRITE ')' ';' END ';'
	;

heteroskedastic_shock_list :
	heteroskedastic_shock_list heteroskedastic_shock_elem
	| heteroskedastic_shock_elem
	;

heteroskedastic_shock_elem :
	VAR symbol ';' PERIODS period_list ';' VALUES value_list ';'
	| VAR symbol ';' PERIODS period_list ';' SCALES value_list ';'
	;

svar_identification :
	SVAR_IDENTIFICATION ';' svar_identification_list END ';'
	;

svar_identification_list :
	svar_identification_list svar_identification_elem
	| svar_identification_elem
	;

svar_identification_elem :
	EXCLUSION LAG INT_NUMBER ';' svar_equation_list
	| EXCLUSION CONSTANTS ';'
	| RESTRICTION EQUATION INT_NUMBER COMMA restriction_expression EQUAL restriction_expression ';'
	| UPPER_CHOLESKY ';'
	| LOWER_CHOLESKY ';'
	;

svar_equation_list :
	svar_equation_list EQUATION INT_NUMBER COMMA symbol_list ';'
	| EQUATION INT_NUMBER COMMA symbol_list ';'
	;

restriction_expression :
	expression
	| restriction_expression_1
	;

restriction_expression_1 :
	restriction_elem_expression
	| restriction_expression_1 restriction_elem_expression
	;

restriction_elem_expression :
	COEFF '(' symbol COMMA INT_NUMBER ')'
	| PLUS /*3L*/ COEFF '(' symbol COMMA INT_NUMBER ')'
	| MINUS /*3L*/ COEFF '(' symbol COMMA INT_NUMBER ')'
	| expression TIMES /*4L*/ COEFF '(' symbol COMMA INT_NUMBER ')'
	;

svar_global_identification_check :
	SVAR_GLOBAL_IDENTIFICATION_CHECK ';'
	;

markov_switching :
	MARKOV_SWITCHING '(' ms_options_list ')' ';'
	;

ms_options_list :
	ms_options_list COMMA ms_options
	| ms_options
	;

ms_options :
	o_chain
	| o_duration
	| o_restrictions
	| o_number_of_regimes
	| o_number_of_lags
	| o_parameters
	;

svar :
	SVAR '(' svar_options_list ')' ';'
	;

svar_options_list :
	svar_options_list COMMA svar_options
	| svar_options
	;

svar_options :
	o_coefficients
	| o_variances
	| o_equations
	| o_chain
	;

mshocks :
	MSHOCKS ';' mshock_list END ';'
	| MSHOCKS '(' OVERWRITE ')' ';' mshock_list END ';'
	;

mshock_list :
	mshock_list det_shock_elem
	| det_shock_elem
	;

period_list :
	period_list COMMA INT_NUMBER
	| period_list INT_NUMBER
	| period_list COMMA INT_NUMBER ':' INT_NUMBER
	| period_list INT_NUMBER ':' INT_NUMBER
	| INT_NUMBER ':' INT_NUMBER
	| INT_NUMBER
	;

value_list :
	value_list COMMA '(' expression ')'
	| value_list '(' expression ')'
	| '(' expression ')'
	| value_list COMMA signed_number
	| value_list signed_number
	| signed_number
	;

steady :
	STEADY ';'
	| STEADY '(' steady_options_list ')' ';'
	;

steady_options_list :
	steady_options_list COMMA steady_options
	| steady_options
	;

steady_options :
	o_solve_algo
	| o_homotopy_mode
	| o_homotopy_steps
	| o_homotopy_force_continue
	| o_markowitz
	| o_steady_maxit
	| o_nocheck
	| o_steady_tolf
	| o_steady_tolx
	| o_fsolve_options
	;

check :
	CHECK ';'
	| CHECK '(' check_options_list ')' ';'
	;

check_options_list :
	check_options_list COMMA check_options
	| check_options
	;

check_options :
	steady_options
	| o_qz_zero_threshold
	;

model_info :
	MODEL_INFO ';'
	| MODEL_INFO '(' model_info_options_list ')' ';'
	;

model_info_options_list :
	model_info_options_list COMMA model_info_options
	| model_info_options
	;

model_info_options :
	o_block_static
	| o_block_dynamic
	| o_incidence
	;

perfect_foresight_setup :
	PERFECT_FORESIGHT_SETUP ';'
	| PERFECT_FORESIGHT_SETUP '(' perfect_foresight_setup_options_list ')' ';'
	;

perfect_foresight_setup_options_list :
	perfect_foresight_setup_options_list COMMA perfect_foresight_setup_options
	| perfect_foresight_setup_options
	;

perfect_foresight_setup_options :
	o_periods
	| o_datafile
	| o_endval_steady
	;

perfect_foresight_solver :
	PERFECT_FORESIGHT_SOLVER ';'
	| PERFECT_FORESIGHT_SOLVER '(' perfect_foresight_solver_options_list ')' ';'
	;

perfect_foresight_solver_options_list :
	perfect_foresight_solver_options_list COMMA perfect_foresight_solver_options
	| perfect_foresight_solver_options
	;

perfect_foresight_solver_options :
	o_stack_solve_algo
	| o_markowitz
	| o_minimal_solving_periods
	| o_simul_maxit
	| o_endogenous_terminal_period
	| o_linear_approximation
	| o_no_homotopy
	| o_solve_algo
	| o_robust_lin_solve
	| o_lmmcp
	| o_pf_tolf
	| o_pf_tolx
	| o_noprint
	| o_print
	| o_pf_steady_solve_algo
	| o_pf_steady_maxit
	| o_pf_steady_tolf
	| o_pf_steady_tolx
	| o_pf_steady_markowitz
	| o_homotopy_max_completion_share
	| o_homotopy_min_step_size
	| o_homotopy_initial_step_size
	| o_homotopy_step_size_increase_success_count
	| o_homotopy_linearization_fallback
	| o_homotopy_marginal_linearization_fallback
	;

perfect_foresight_with_expectation_errors_setup :
	PERFECT_FORESIGHT_WITH_EXPECTATION_ERRORS_SETUP ';'
	| PERFECT_FORESIGHT_WITH_EXPECTATION_ERRORS_SETUP '(' perfect_foresight_with_expectation_errors_setup_options_list ')' ';'
	;

perfect_foresight_with_expectation_errors_setup_options_list :
	perfect_foresight_with_expectation_errors_setup_options_list COMMA perfect_foresight_with_expectation_errors_setup_options
	| perfect_foresight_with_expectation_errors_setup_options
	;

perfect_foresight_with_expectation_errors_setup_options :
	o_periods
	| o_datafile
	;

perfect_foresight_with_expectation_errors_solver :
	PERFECT_FORESIGHT_WITH_EXPECTATION_ERRORS_SOLVER ';'
	| PERFECT_FORESIGHT_WITH_EXPECTATION_ERRORS_SOLVER '(' perfect_foresight_with_expectation_errors_solver_options_list ')' ';'
	;

perfect_foresight_with_expectation_errors_solver_options_list :
	perfect_foresight_with_expectation_errors_solver_options_list COMMA perfect_foresight_with_expectation_errors_solver_options
	| perfect_foresight_with_expectation_errors_solver_options
	;

perfect_foresight_with_expectation_errors_solver_options :
	o_pfwee_constant_simulation_length
	| perfect_foresight_solver_options
	;

method_of_moments :
	METHOD_OF_MOMENTS ';'
	| METHOD_OF_MOMENTS '(' method_of_moments_options_list ')' ';'
	;

method_of_moments_options_list :
	method_of_moments_option COMMA method_of_moments_options_list
	| method_of_moments_option
	;

method_of_moments_option :
	o_mom_method
	| o_datafile
	| o_bartlett_kernel_lag
	| o_order
	| o_penalized_estimator
	| o_pruning
	| o_verbose
	| o_weighting_matrix
	| o_weighting_matrix_scaling_factor
	| o_mom_se_tolx
	| o_mom_burnin
	| o_bounded_shock_support
	| o_mom_seed
	| o_simulation_multiple
	| o_analytic_standard_errors
	| o_dirname
	| o_graph_format
	| o_nodisplay
	| o_nograph
	| o_noprint
	| o_plot_priors
	| o_prior_trunc
	| o_tex
	| o_first_obs
	| o_logdata
	| o_nobs
	| o_prefilter
	| o_xls_sheet
	| o_xls_range
	| o_mode_compute
	| o_additional_optimizer_steps
	| o_optim
	| o_silent_optimizer
	| o_huge_number
	| o_analytic_jacobian
	| o_aim_solver
	| o_dr
	| o_dr_cycle_reduction_tol
	| o_dr_logarithmic_reduction_tol
	| o_dr_logarithmic_reduction_maxiter
	| o_k_order_solver
	| o_lyapunov
	| o_lyapunov_complex_threshold
	| o_lyapunov_fixed_point_tol
	| o_lyapunov_doubling_tol
	| o_sylvester
	| o_sylvester_fixed_point_tol
	| o_qz_criterium
	| o_qz_zero_threshold
	| o_schur_vec_tol
	| o_zero_moments_tolerance
	| o_mode_check
	| o_mode_check_neighbourhood_size
	| o_mode_check_symmetric_plots
	| o_mode_check_number_of_points
	;

prior_function :
	PRIOR_FUNCTION '(' prior_posterior_function_options_list ')' ';'
	;

posterior_function :
	POSTERIOR_FUNCTION '(' prior_posterior_function_options_list ')' ';'
	;

prior_posterior_function_options_list :
	prior_posterior_function_options_list COMMA prior_posterior_function_options
	| prior_posterior_function_options
	;

prior_posterior_function_options :
	o_function
	| o_sampling_draws
	;

simul :
	SIMUL ';'
	| SIMUL '(' simul_options_list ')' ';'
	;

simul_options_list :
	simul_options_list COMMA simul_options
	| simul_options
	;

simul_options :
	perfect_foresight_setup_options
	| perfect_foresight_solver_options
	;

external_function :
	EXTERNAL_FUNCTION '(' external_function_options_list ')' ';'
	;

external_function_options_list :
	external_function_options_list COMMA external_function_options
	| external_function_options
	;

external_function_options :
	o_ext_func_name
	| o_ext_func_nargs
	| o_first_deriv_provided
	| o_second_deriv_provided
	;

stoch_simul :
	STOCH_SIMUL ';'
	| STOCH_SIMUL '(' stoch_simul_options_list ')' ';'
	| STOCH_SIMUL symbol_list ';'
	| STOCH_SIMUL '(' stoch_simul_options_list ')' symbol_list ';'
	;

stoch_simul_options_list :
	stoch_simul_options_list COMMA stoch_simul_options
	| stoch_simul_options
	;

stoch_simul_primary_options :
	o_dr_algo
	| o_solve_algo
	| o_simul_algo
	| o_order
	| o_replic
	| o_drop
	| o_ar
	| o_nocorr
	| o_contemporaneous_correlation
	| o_nofunctions
	| o_nomoments
	| o_nograph
	| o_nodisplay
	| o_graph_format
	| o_irf
	| o_irf_shocks
	| o_relative_irf
	| o_analytical_girf
	| o_irf_in_percent
	| o_emas_girf
	| o_emas_drop
	| o_emas_tolf
	| o_emas_max_iter
	| o_stderr_multiples
	| o_diagonal_only
	| o_hp_filter
	| o_hp_ngrid
	| o_filtered_theoretical_moments_grid
	| o_periods
	| o_simul
	| o_simul_seed
	| o_simul_replic
	| o_qz_criterium
	| o_qz_zero_threshold
	| o_print
	| o_noprint
	| o_aim_solver
	| o_partial_information
	| o_conditional_variance_decomposition
	| o_k_order_solver
	| o_pruning
	| o_sylvester
	| o_sylvester_fixed_point_tol
	| o_dr
	| o_dr_cycle_reduction_tol
	| o_dr_logarithmic_reduction_tol
	| o_dr_logarithmic_reduction_maxiter
	| o_irf_plot_threshold
	| o_dr_display_tol
	| o_tex
	;

stoch_simul_options :
	stoch_simul_primary_options
	| o_loglinear
	| o_nodecomposition
	| o_spectral_density
	| o_bandpass_filter
	| o_one_sided_hp_filter
	;

signed_integer :
	PLUS /*3L*/ INT_NUMBER
	| MINUS /*3L*/ INT_NUMBER
	| INT_NUMBER
	;

non_negative_number :
	INT_NUMBER
	| FLOAT_NUMBER
	;

signed_number :
	PLUS /*3L*/ non_negative_number
	| MINUS /*3L*/ non_negative_number
	| non_negative_number
	;

signed_inf :
	PLUS /*3L*/ INF_CONSTANT
	| MINUS /*3L*/ INF_CONSTANT
	| INF_CONSTANT
	;

signed_number_w_inf :
	signed_inf
	| signed_number
	;

boolean :
	TRUE
	| FALSE
	;

estimated_params :
	ESTIMATED_PARAMS ';' estimated_list END ';'
	| ESTIMATED_PARAMS '(' OVERWRITE ')' ';' estimated_list END ';'
	;

estimated_list :
	estimated_list estimated_elem
	| estimated_elem
	;

estimated_elem :
	estimated_elem1 COMMA estimated_elem2 ';'
	| estimated_elem1 ';'
	;

estimated_elem1 :
	STDERR symbol
	| symbol
	| CORR symbol COMMA symbol
	| DSGE_PRIOR_WEIGHT
	;

estimated_elem2 :
	prior_pdf COMMA estimated_elem3
	| expression_or_empty COMMA prior_pdf COMMA estimated_elem3
	| expression_or_empty COMMA expression_or_empty COMMA expression_or_empty COMMA prior_pdf COMMA estimated_elem3
	| expression
	| expression_or_empty COMMA expression_or_empty COMMA expression_or_empty
	;

estimated_elem3 :
	expression_or_empty COMMA expression_or_empty
	| expression_or_empty COMMA expression_or_empty COMMA expression_or_empty
	| expression_or_empty COMMA expression_or_empty COMMA expression_or_empty COMMA expression_or_empty
	| expression_or_empty COMMA expression_or_empty COMMA expression_or_empty COMMA expression_or_empty COMMA expression
	;

estimated_params_init :
	ESTIMATED_PARAMS_INIT ';' estimated_init_list END ';'
	| ESTIMATED_PARAMS_INIT '(' USE_CALIBRATION ')' ';' END ';'
	| ESTIMATED_PARAMS_INIT '(' USE_CALIBRATION ')' ';' estimated_init_list END ';'
	;

estimated_init_list :
	estimated_init_list estimated_init_elem
	| estimated_init_elem
	;

estimated_init_elem :
	STDERR symbol COMMA expression ';'
	| CORR symbol COMMA symbol COMMA expression ';'
	| symbol COMMA expression ';'
	;

estimated_params_bounds :
	ESTIMATED_PARAMS_BOUNDS ';' estimated_bounds_list END ';'
	;

estimated_bounds_list :
	estimated_bounds_list estimated_bounds_elem
	| estimated_bounds_elem
	;

estimated_bounds_elem :
	STDERR symbol COMMA expression COMMA expression ';'
	| CORR symbol COMMA symbol COMMA expression COMMA expression ';'
	| symbol COMMA expression COMMA expression ';'
	;

estimated_params_remove :
	ESTIMATED_PARAMS_REMOVE ';' estimated_remove_list END ';'
	;

estimated_remove_list :
	estimated_remove_elem
	| estimated_remove_list estimated_remove_elem
	;

estimated_remove_elem :
	estimated_elem1 ';'
	;

osr_params_bounds :
	OSR_PARAMS_BOUNDS ';' osr_bounds_list END ';'
	;

osr_bounds_list :
	osr_bounds_list osr_bounds_elem
	| osr_bounds_elem
	;

osr_bounds_elem :
	symbol COMMA expression COMMA expression ';'
	;

prior_distribution :
	BETA
	| GAMMA
	| NORMAL
	| INV_GAMMA
	| INV_GAMMA1
	| UNIFORM
	| INV_GAMMA2
	| DIRICHLET
	| WEIBULL
	;

prior_pdf :
	BETA_PDF
	| GAMMA_PDF
	| NORMAL_PDF
	| INV_GAMMA_PDF
	| INV_GAMMA1_PDF
	| UNIFORM_PDF
	| INV_GAMMA2_PDF
	| WEIBULL_PDF
	;

date_str :
	DATES
	;

date_expr :
	date_str
	| date_expr PLUS /*3L*/ INT_NUMBER
	;

set_time :
	SET_TIME '(' date_expr ')' ';'
	;

data :
	DATA '(' data_options_list ')' ';'
	;

data_options_list :
	data_options_list COMMA data_options
	| data_options
	;

data_options :
	o_file
	| o_series
	| o_data_first_obs
	| o_data_last_obs
	| o_data_nobs
	| o_xls_sheet
	| o_xls_range
	;

subsamples :
	subsamples_eq_opt '(' subsamples_name_list ')' ';'
	;

subsamples_eq :
	subsamples_eq_opt EQUAL subsamples_eq_opt ';'
	;

subsamples_eq_opt :
	symbol '.' SUBSAMPLES
	| STD '(' symbol ')' '.' SUBSAMPLES
	| CORR '(' symbol COMMA symbol ')' '.' SUBSAMPLES
	;

subsamples_name_list :
	subsamples_name_list COMMA o_subsample_name
	| o_subsample_name
	;

prior :
	symbol '.' PRIOR '(' prior_options_list ')' ';'
	| symbol '.' symbol '.' PRIOR '(' prior_options_list ')' ';'
	| SYMBOL_VEC '.' PRIOR '(' joint_prior_options_list ')' ';'
	| STD '(' symbol ')' '.' PRIOR '(' prior_options_list ')' ';'
	| STD '(' symbol ')' '.' symbol '.' PRIOR '(' prior_options_list ')' ';'
	| CORR '(' symbol COMMA symbol ')' '.' PRIOR '(' prior_options_list ')' ';'
	| CORR '(' symbol COMMA symbol ')' '.' symbol '.' PRIOR '(' prior_options_list ')' ';'
	;

prior_options_list :
	prior_options_list COMMA prior_options
	| prior_options
	;

prior_options :
	o_shift
	| o_mean
	| o_median
	| o_stdev
	| o_truncate
	| o_variance
	| o_mode
	| o_interval
	| o_shape
	| o_domain
	;

joint_prior_options_list :
	joint_prior_options_list COMMA joint_prior_options
	| joint_prior_options
	;

joint_prior_options :
	o_shift
	| o_mean_vec
	| o_median
	| o_stdev
	| o_truncate
	| o_variance_mat
	| o_mode
	| o_interval
	| o_shape
	| o_domain
	;

prior_eq :
	prior_eq_opt EQUAL prior_eq_opt ';'
	;

prior_eq_opt :
	symbol '.' PRIOR
	| symbol '.' symbol '.' PRIOR
	| STD '(' symbol ')' '.' PRIOR
	| STD '(' symbol ')' '.' symbol '.' PRIOR
	| CORR '(' symbol COMMA symbol ')' '.' PRIOR
	| CORR '(' symbol COMMA symbol ')' '.' symbol '.' PRIOR
	;

options :
	symbol '.' OPTIONS '(' options_options_list ')' ';'
	| symbol '.' symbol '.' OPTIONS '(' options_options_list ')' ';'
	| STD '(' symbol ')' '.' OPTIONS '(' options_options_list ')' ';'
	| STD '(' symbol ')' '.' symbol '.' OPTIONS '(' options_options_list ')' ';'
	| CORR '(' symbol COMMA symbol ')' '.' OPTIONS '(' options_options_list ')' ';'
	| CORR '(' symbol COMMA symbol ')' '.' symbol '.' OPTIONS '(' options_options_list ')' ';'
	;

options_options_list :
	options_options_list COMMA options_options
	| options_options
	;

options_options :
	o_jscale
	| o_init
	| o_bounds
	;

options_eq :
	options_eq_opt EQUAL options_eq_opt ';'
	;

options_eq_opt :
	symbol '.' OPTIONS
	| symbol '.' symbol '.' OPTIONS
	| STD '(' symbol ')' '.' OPTIONS
	| STD '(' symbol ')' '.' symbol '.' OPTIONS
	| CORR '(' symbol COMMA symbol ')' '.' OPTIONS
	| CORR '(' symbol COMMA symbol ')' '.' symbol '.' OPTIONS
	;

estimation :
	ESTIMATION ';'
	| ESTIMATION '(' estimation_options_list ')' ';'
	| ESTIMATION symbol_list ';'
	| ESTIMATION '(' estimation_options_list ')' symbol_list ';'
	;

estimation_options_list :
	estimation_options_list COMMA estimation_options
	| estimation_options
	;

estimation_options :
	o_datafile
	| o_nobs
	| o_est_first_obs
	| o_prefilter
	| o_presample
	| o_lik_algo
	| o_lik_init
	| o_nograph
	| o_posterior_nograph
	| o_nodisplay
	| o_graph_format
	| o_forecasts_conf_sig
	| o_mh_conf_sig
	| o_mh_replic
	| o_mh_drop
	| o_mh_jscale
	| o_mh_tune_jscale
	| o_mh_tune_guess
	| o_optim
	| o_mh_init_scale
	| o_mh_init_scale_factor
	| o_mode_file
	| o_mode_compute
	| o_additional_optimizer_steps
	| o_mode_check
	| o_mode_check_neighbourhood_size
	| o_mode_check_symmetric_plots
	| o_mode_check_number_of_points
	| o_prior_trunc
	| o_mh_posterior_mode_estimation
	| o_mh_nblocks
	| o_load_mh_file
	| o_load_results_after_load_mh
	| o_loglinear
	| o_logdata
	| o_nodecomposition
	| o_nodiagnostic
	| o_bayesian_irf
	| o_relative_irf
	| o_dsge_var
	| o_dsge_varlag
	| o_irf
	| o_tex
	| o_forecast
	| o_smoother
	| o_moments_varendo
	| o_contemporaneous_correlation
	| o_filtered_vars
	| o_conditional_likelihood
	| o_fast_kalman_filter
	| o_kalman_algo
	| o_kalman_tol
	| o_diffuse_kalman_tol
	| o_xls_sheet
	| o_xls_range
	| o_filter_step_ahead
	| o_solve_algo
	| o_constant
	| o_noconstant
	| o_mh_recover
	| o_mh_initialize_from_previous_mcmc
	| o_mh_initialize_from_previous_mcmc_directory
	| o_mh_initialize_from_previous_mcmc_record
	| o_mh_initialize_from_previous_mcmc_prior
	| o_diffuse_filter
	| o_plot_priors
	| o_order
	| o_aim_solver
	| o_partial_information
	| o_filter_covariance
	| o_updated_covariance
	| o_filter_decomposition
	| o_smoothed_state_uncertainty
	| o_smoother_redux
	| o_selected_variables_only
	| o_conditional_variance_decomposition
	| o_cova_compute
	| o_irf_shocks
	| o_sub_draws
	| o_sylvester
	| o_sylvester_fixed_point_tol
	| o_lyapunov
	| o_lyapunov_fixed_point_tol
	| o_lyapunov_doubling_tol
	| o_dr
	| o_dr_cycle_reduction_tol
	| o_dr_logarithmic_reduction_tol
	| o_dr_logarithmic_reduction_maxiter
	| o_analytic_derivation
	| o_ar
	| o_endogenous_prior
	| o_use_univariate_filters_if_singularity_is_detected
	| o_qz_zero_threshold
	| o_taper_steps
	| o_geweke_interval
	| o_raftery_lewis_qrs
	| o_raftery_lewis_diagnostics
	| o_brooks_gelman_plotrows
	| o_mcmc_jumping_covariance
	| o_irf_plot_threshold
	| o_posterior_max_subsample_draws
	| o_consider_all_endogenous
	| o_consider_all_endogenous_and_auxiliary
	| o_consider_only_observed
	| o_number_of_particles
	| o_particle_filter_options
	| o_resampling
	| o_resampling_threshold
	| o_resampling_method
	| o_filter_algorithm
	| o_nonlinear_filter_initialization
	| o_cpf_weights
	| o_proposal_approximation
	| o_distribution_approximation
	| o_dirname
	| o_huge_number
	| o_silent_optimizer
	| o_proposal_distribution
	| o_no_posterior_kernel_density
	| o_posterior_sampling_method
	| o_posterior_sampler_options
	| o_keep_kalman_algo_if_singularity_is_detected
	| o_use_penalized_objective_for_hessian
	| o_rescale_prediction_error_covariance
	| o_analytical_girf
	| o_irf_in_percent
	| o_emas_girf
	| o_emas_drop
	| o_emas_tolf
	| o_emas_max_iter
	| o_stderr_multiples
	| o_diagonal_only
	| o_no_init_estimation_check_first_obs
	| o_heteroskedastic_filter
	;

name_value_pair :
	QUOTED_STRING COMMA QUOTED_STRING
	| QUOTED_STRING COMMA signed_number
	;

name_value_pair_list :
	name_value_pair
	| name_value_pair_list COMMA name_value_pair
	;

name_value_pair_with_boolean :
	name_value_pair
	| QUOTED_STRING COMMA boolean
	;

name_value_pair_with_boolean_list :
	name_value_pair_with_boolean
	| name_value_pair_with_boolean_list COMMA name_value_pair_with_boolean
	;

name_value_pair_with_suboptions :
	name_value_pair
	| QUOTED_STRING COMMA vec_str
	| QUOTED_STRING COMMA '(' name_value_pair_list ')'
	;

name_value_pair_with_suboptions_list :
	name_value_pair_with_suboptions
	| name_value_pair_with_suboptions_list COMMA name_value_pair_with_suboptions
	;

varobs :
	VAROBS varobs_list ';'
	;

varobs_list :
	varobs_list symbol
	| varobs_list COMMA symbol
	| symbol
	;

varexobs :
	VAREXOBS varexobs_list ';'
	;

varexobs_list :
	varexobs_list symbol
	| varexobs_list COMMA symbol
	| symbol
	;

deterministic_trends :
	DETERMINISTIC_TRENDS ';' trend_list END ';'
	;

observation_trends :
	OBSERVATION_TRENDS ';' trend_list END ';'
	;

trend_list :
	trend_list trend_element
	| trend_element
	;

trend_element :
	symbol '(' expression ')' ';'
	;

filter_initial_state :
	FILTER_INITIAL_STATE ';' filter_initial_state_list END ';'
	;

filter_initial_state_list :
	filter_initial_state_list filter_initial_state_element
	| filter_initial_state_element
	;

filter_initial_state_element :
	symbol '(' signed_integer ')' EQUAL expression ';'
	;

unit_root_vars :
	UNIT_ROOT_VARS symbol_list ';'
	;

optim_weights :
	OPTIM_WEIGHTS ';' optim_weights_list END ';'
	;

optim_weights_list :
	optim_weights_list symbol expression ';'
	| optim_weights_list symbol COMMA symbol expression ';'
	| symbol expression ';'
	| symbol COMMA symbol expression ';'
	;

osr_params :
	OSR_PARAMS symbol_list ';'
	;

osr_options_list :
	osr_options_list COMMA osr_options
	| osr_options
	;

osr_options :
	stoch_simul_primary_options
	| o_osr_maxit
	| o_osr_tolf
	| o_opt_algo
	| o_optim
	| o_huge_number
	| o_silent_optimizer
	| o_analytic_derivation
	| o_analytic_derivation_mode
	;

osr :
	OSR ';'
	| OSR '(' osr_options_list ')' ';'
	| OSR symbol_list ';'
	| OSR '(' osr_options_list ')' symbol_list ';'
	;

dynatype :
	DYNATYPE '(' filename ')' ';'
	| DYNATYPE '(' filename ')' symbol_list ';'
	;

dynasave :
	DYNASAVE '(' filename ')' ';'
	| DYNASAVE '(' filename ')' symbol_list ';'
	;

load_params_and_steady_state :
	LOAD_PARAMS_AND_STEADY_STATE '(' filename ')' ';'
	;

save_params_and_steady_state :
	SAVE_PARAMS_AND_STEADY_STATE '(' filename ')' ';'
	;

identification :
	IDENTIFICATION ';'
	| IDENTIFICATION '(' identification_options_list ')' ';'
	;

identification_options_list :
	identification_option COMMA identification_options_list
	| identification_option
	;

identification_option :
	o_ar
	| o_useautocorr
	| o_load_ident_files
	| o_prior_mc
	| o_advanced
	| o_max_dim_cova_group
	| o_gsa_prior_range
	| o_periods
	| o_replic
	| o_gsa_sample_file
	| o_parameter_set
	| o_lik_init
	| o_kalman_algo
	| o_nograph
	| o_nodisplay
	| o_graph_format
	| o_diffuse_filter
	| o_prior_trunc
	| o_analytic_derivation
	| o_analytic_derivation_mode
	| o_tex
	| o_no_identification_strength
	| o_no_identification_reducedform
	| o_no_identification_moments
	| o_no_identification_minimal
	| o_no_identification_spectrum
	| o_normalize_jacobians
	| o_grid_nbr
	| o_tol_rank
	| o_tol_deriv
	| o_tol_sv
	| o_checks_via_subsets
	| o_max_dim_subsets_groups
	| o_order
	| o_schur_vec_tol
	| o_zero_moments_tolerance
	;

model_comparison :
	MODEL_COMPARISON mc_filename_list ';'
	| MODEL_COMPARISON '(' o_marginal_density ')' mc_filename_list ';'
	;

filename :
	symbol
	| QUOTED_STRING
	;

namespace_qualified_symbol :
	symbol
	| namespace_qualified_symbol '.' symbol
	;

namespace_qualified_filename :
	namespace_qualified_symbol
	| QUOTED_STRING
	;

parallel_local_filename_list :
	filename
	| parallel_local_filename_list COMMA filename
	;

mc_filename_list :
	filename
	| filename '(' non_negative_number ')'
	| mc_filename_list filename
	| mc_filename_list filename '(' non_negative_number ')'
	| mc_filename_list COMMA filename
	| mc_filename_list COMMA filename '(' non_negative_number ')'
	;

planner_objective :
	PLANNER_OBJECTIVE hand_side ';'
	;

ramsey_model :
	RAMSEY_MODEL ';'
	| RAMSEY_MODEL '(' ramsey_model_options_list ')' ';'
	;

ramsey_policy :
	RAMSEY_POLICY ';'
	| RAMSEY_POLICY '(' ramsey_policy_options_list ')' ';'
	| RAMSEY_POLICY symbol_list ';'
	| RAMSEY_POLICY '(' ramsey_policy_options_list ')' symbol_list ';'
	;

ramsey_constraints :
	RAMSEY_CONSTRAINTS ';' ramsey_constraints_list END ';'
	;

ramsey_constraints_list :
	ramsey_constraints_list ramsey_constraint
	| ramsey_constraint
	;

ramsey_constraint :
	NAME LESS /*2L*/ expression ';'
	| NAME GREATER /*2L*/ expression ';'
	| NAME LESS_EQUAL /*2L*/ expression ';'
	| NAME GREATER_EQUAL /*2L*/ expression ';'
	;

evaluate_planner_objective :
	EVALUATE_PLANNER_OBJECTIVE ';'
	| EVALUATE_PLANNER_OBJECTIVE '(' evaluate_planner_objective_options_list ')' ';'
	;

evaluate_planner_objective_options_list :
	evaluate_planner_objective_option COMMA evaluate_planner_objective_options_list
	| evaluate_planner_objective_option
	;

evaluate_planner_objective_option :
	o_evaluate_planner_objective_periods
	| o_evaluate_planner_objective_drop
	;

occbin_setup :
	OCCBIN_SETUP ';'
	| OCCBIN_SETUP '(' occbin_setup_options_list ')' ';'
	;

occbin_setup_options_list :
	occbin_setup_option COMMA occbin_setup_options_list
	| occbin_setup_option
	;

occbin_setup_option :
	o_occbin_simul_periods
	| o_occbin_simul_maxit
	| o_occbin_simul_curb_retrench
	| o_occbin_simul_check_ahead_periods
	| o_occbin_simul_max_check_ahead_periods
	| o_occbin_simul_periodic_solution
	| o_occbin_simul_debug
	| o_occbin_simul_reset_check_ahead_periods
	| o_occbin_likelihood_periods
	| o_occbin_likelihood_maxit
	| o_occbin_likelihood_curb_retrench
	| o_occbin_likelihood_check_ahead_periods
	| o_occbin_likelihood_max_check_ahead_periods
	| o_occbin_likelihood_periodic_solution
	| o_occbin_likelihood_max_kalman_iterations
	| o_occbin_likelihood_inversion_filter
	| o_occbin_likelihood_piecewise_kalman_filter
	| o_occbin_smoother_periods
	| o_occbin_smoother_maxit
	| o_occbin_smoother_curb_retrench
	| o_occbin_smoother_check_ahead_periods
	| o_occbin_smoother_max_check_ahead_periods
	| o_occbin_smoother_periodic_solution
	| o_occbin_smoother_inversion_filter
	| o_occbin_smoother_piecewise_kalman_filter
	| o_occbin_smoother_debug
	| o_occbin_filter_use_relaxation
	;

occbin_solver :
	OCCBIN_SOLVER ';'
	| OCCBIN_SOLVER '(' occbin_solver_options_list ')' ';'
	;

occbin_solver_options_list :
	occbin_solver_option COMMA occbin_solver_options_list
	| occbin_solver_option
	;

occbin_solver_option :
	o_occbin_simul_periods
	| o_occbin_simul_maxit
	| o_occbin_simul_curb_retrench
	| o_occbin_simul_check_ahead_periods
	| o_occbin_simul_max_check_ahead_periods
	| o_occbin_simul_reset_check_ahead_periods
	| o_occbin_simul_debug
	| o_occbin_simul_periodic_solution
	;

occbin_write_regimes :
	OCCBIN_WRITE_REGIMES ';'
	| OCCBIN_WRITE_REGIMES '(' occbin_write_regimes_options_list ')' ';'
	;

occbin_write_regimes_options_list :
	occbin_write_regimes_option COMMA occbin_write_regimes_options_list
	| occbin_write_regimes_option
	;

occbin_write_regimes_option :
	o_occbin_write_regimes_periods
	| o_occbin_write_regimes_filename
	| o_occbin_write_regimes_smoother
	| o_occbin_write_regimes_simul
	;

occbin_graph :
	OCCBIN_GRAPH ';'
	| OCCBIN_GRAPH '(' occbin_graph_options_list ')' ';'
	| OCCBIN_GRAPH symbol_list ';'
	| OCCBIN_GRAPH '(' occbin_graph_options_list ')' symbol_list ';'
	;

occbin_graph_options_list :
	occbin_graph_option COMMA occbin_graph_options_list
	| occbin_graph_option
	;

occbin_graph_option :
	o_occbin_graph_noconstant
	;

discretionary_policy :
	DISCRETIONARY_POLICY ';'
	| DISCRETIONARY_POLICY '(' discretionary_policy_options_list ')' ';'
	| DISCRETIONARY_POLICY symbol_list ';'
	| DISCRETIONARY_POLICY '(' discretionary_policy_options_list ')' symbol_list ';'
	;

discretionary_policy_options_list :
	discretionary_policy_options_list COMMA discretionary_policy_options
	| discretionary_policy_options
	;

discretionary_policy_options :
	ramsey_policy_options
	| o_discretionary_tol
	| o_dp_maxit
	;

ramsey_model_options_list :
	ramsey_model_options_list COMMA ramsey_model_options
	| ramsey_model_options
	;

ramsey_model_options :
	o_planner_discount
	| o_planner_discount_latex_name
	| o_instruments
	;

ramsey_policy_options_list :
	ramsey_policy_options_list COMMA ramsey_policy_options
	| ramsey_policy_options
	;

ramsey_policy_options :
	stoch_simul_primary_options
	| o_planner_discount
	| o_instruments
	;

write_latex_dynamic_model :
	WRITE_LATEX_DYNAMIC_MODEL ';'
	| WRITE_LATEX_DYNAMIC_MODEL '(' WRITE_EQUATION_TAGS ')' ';'
	;

write_latex_static_model :
	WRITE_LATEX_STATIC_MODEL ';'
	| WRITE_LATEX_STATIC_MODEL '(' WRITE_EQUATION_TAGS ')' ';'
	;

write_latex_original_model :
	WRITE_LATEX_ORIGINAL_MODEL ';'
	| WRITE_LATEX_ORIGINAL_MODEL '(' WRITE_EQUATION_TAGS ')' ';'
	;

write_latex_steady_state_model :
	WRITE_LATEX_STEADY_STATE_MODEL ';'
	;

shock_decomposition :
	SHOCK_DECOMPOSITION ';'
	| SHOCK_DECOMPOSITION '(' shock_decomposition_options_list ')' ';'
	| SHOCK_DECOMPOSITION symbol_list ';'
	| SHOCK_DECOMPOSITION '(' shock_decomposition_options_list ')' symbol_list ';'
	;

realtime_shock_decomposition :
	REALTIME_SHOCK_DECOMPOSITION ';'
	| REALTIME_SHOCK_DECOMPOSITION '(' realtime_shock_decomposition_options_list ')' ';'
	| REALTIME_SHOCK_DECOMPOSITION symbol_list ';'
	| REALTIME_SHOCK_DECOMPOSITION '(' realtime_shock_decomposition_options_list ')' symbol_list ';'
	;

plot_shock_decomposition :
	PLOT_SHOCK_DECOMPOSITION ';'
	| PLOT_SHOCK_DECOMPOSITION '(' plot_shock_decomposition_options_list ')' ';'
	| PLOT_SHOCK_DECOMPOSITION symbol_list ';'
	| PLOT_SHOCK_DECOMPOSITION '(' plot_shock_decomposition_options_list ')' symbol_list ';'
	;

initial_condition_decomposition :
	INITIAL_CONDITION_DECOMPOSITION ';'
	| INITIAL_CONDITION_DECOMPOSITION '(' initial_condition_decomposition_options_list ')' ';'
	| INITIAL_CONDITION_DECOMPOSITION symbol_list ';'
	| INITIAL_CONDITION_DECOMPOSITION '(' initial_condition_decomposition_options_list ')' symbol_list ';'
	;

squeeze_shock_decomposition :
	SQUEEZE_SHOCK_DECOMPOSITION ';'
	| SQUEEZE_SHOCK_DECOMPOSITION symbol_list ';'
	;

bvar_prior_option :
	o_bvar_prior_tau
	| o_bvar_prior_decay
	| o_bvar_prior_lambda
	| o_bvar_prior_mu
	| o_bvar_prior_omega
	| o_bvar_prior_flat
	| o_bvar_prior_train
	;

bvar_common_option :
	bvar_prior_option
	| o_datafile
	| o_xls_sheet
	| o_xls_range
	| o_first_obs
	| o_presample
	| o_nobs
	| o_prefilter
	| o_constant
	| o_noconstant
	;

bvar_density_options_list :
	bvar_common_option COMMA bvar_density_options_list
	| bvar_common_option
	;

bvar_density :
	BVAR_DENSITY INT_NUMBER ';'
	| BVAR_DENSITY '(' bvar_density_options_list ')' INT_NUMBER ';'
	;

bvar_forecast_option :
	bvar_common_option
	| o_forecast
	| o_bvar_conf_sig
	| o_bvar_replic
	;

bvar_forecast_options_list :
	bvar_forecast_option COMMA bvar_forecast_options_list
	| bvar_forecast_option
	;

bvar_forecast :
	BVAR_FORECAST INT_NUMBER ';'
	| BVAR_FORECAST '(' bvar_forecast_options_list ')' INT_NUMBER ';'
	;

bvar_irf :
	BVAR_IRF '(' INT_NUMBER COMMA QUOTED_STRING ')' ';'
	;

sbvar_option :
	o_datafile
	| o_freq
	| o_initial_year
	| o_initial_subperiod
	| o_final_year
	| o_final_subperiod
	| o_data
	| o_vlist
	| o_vlistlog
	| o_vlistper
	| o_restriction_fname
	| o_nlags
	| o_cross_restrictions
	| o_contemp_reduced_form
	| o_real_pseudo_forecast
	| o_no_bayesian_prior
	| o_dummy_obs
	| o_nstates
	| o_indxscalesstates
	| o_alpha
	| o_beta
	| o_gsig2_lmdm
	| o_q_diag
	| o_flat_prior
	| o_ncsk
	| o_nstd
	| o_ninv
	| o_indxparr
	| o_indxovr
	| o_aband
	| o_indxap
	| o_apband
	| o_indximf
	| o_indxfore
	| o_foreband
	| o_indxgforhat
	| o_indxgimfhat
	| o_indxestima
	| o_indxgdls
	| o_eq_ms
	| o_cms
	| o_ncms
	| o_eq_cms
	| o_tlindx
	| o_tlnumber
	| o_cnum
	| o_forecast
	| o_coefficients_prior_hyperparameters
	;

sbvar_options_list :
	sbvar_option COMMA sbvar_options_list
	| sbvar_option
	;

sbvar :
	SBVAR ';'
	| SBVAR '(' sbvar_options_list ')' ';'
	;

ms_variance_decomposition_option :
	o_output_file_tag
	| o_file_tag
	| o_simulation_file_tag
	| o_filtered_probabilities
	| o_no_error_bands
	| o_error_band_percentiles
	| o_shock_draws
	| o_shocks_per_parameter
	| o_thinning_factor
	| o_free_parameters
	| o_regime
	| o_regimes
	| o_parameter_uncertainty
	| o_horizon
	;

ms_variance_decomposition_options_list :
	ms_variance_decomposition_option COMMA ms_variance_decomposition_options_list
	| ms_variance_decomposition_option
	;

ms_variance_decomposition :
	MS_VARIANCE_DECOMPOSITION ';'
	| MS_VARIANCE_DECOMPOSITION '(' ms_variance_decomposition_options_list ')' ';'
	;

ms_forecast_option :
	o_output_file_tag
	| o_file_tag
	| o_simulation_file_tag
	| o_data_obs_nbr
	| o_error_band_percentiles
	| o_shock_draws
	| o_shocks_per_parameter
	| o_thinning_factor
	| o_free_parameters
	| o_median
	| o_regime
	| o_regimes
	| o_parameter_uncertainty
	| o_horizon
	;

ms_forecast_options_list :
	ms_forecast_option COMMA ms_forecast_options_list
	| ms_forecast_option
	;

ms_forecast :
	MS_FORECAST ';'
	| MS_FORECAST '(' ms_forecast_options_list ')' ';'
	;

ms_irf_option :
	o_output_file_tag
	| o_file_tag
	| o_simulation_file_tag
	| o_parameter_uncertainty
	| o_horizon
	| o_filtered_probabilities
	| o_error_band_percentiles
	| o_shock_draws
	| o_shocks_per_parameter
	| o_thinning_factor
	| o_free_parameters
	| o_median
	| o_regime
	| o_regimes
	;

ms_irf_options_list :
	ms_irf_option COMMA ms_irf_options_list
	| ms_irf_option
	;

ms_irf :
	MS_IRF ';'
	| MS_IRF '(' ms_irf_options_list ')' ';'
	| MS_IRF symbol_list ';'
	| MS_IRF '(' ms_irf_options_list ')' symbol_list ';'
	;

ms_compute_probabilities_option :
	o_output_file_tag
	| o_file_tag
	| o_filtered_probabilities
	| o_real_time_smoothed
	;

ms_compute_probabilities_options_list :
	ms_compute_probabilities_option COMMA ms_compute_probabilities_options_list
	| ms_compute_probabilities_option
	;

ms_compute_probabilities :
	MS_COMPUTE_PROBABILITIES ';'
	| MS_COMPUTE_PROBABILITIES '(' ms_compute_probabilities_options_list ')' ';'
	;

ms_compute_mdd_option :
	o_output_file_tag
	| o_file_tag
	| o_simulation_file_tag
	| o_proposal_type
	| o_proposal_lower_bound
	| o_proposal_upper_bound
	| o_proposal_draws
	| o_use_mean_center
	;

ms_compute_mdd_options_list :
	ms_compute_mdd_option COMMA ms_compute_mdd_options_list
	| ms_compute_mdd_option
	;

ms_compute_mdd :
	MS_COMPUTE_MDD ';'
	| MS_COMPUTE_MDD '(' ms_compute_mdd_options_list ')' ';'
	;

ms_simulation_option :
	o_output_file_tag
	| o_file_tag
	| o_ms_mh_replic
	| o_ms_drop
	| o_thinning_factor
	| o_adaptive_mh_draws
	| o_save_draws
	;

ms_simulation_options_list :
	ms_simulation_option COMMA ms_simulation_options_list
	| ms_simulation_option
	;

ms_simulation :
	MS_SIMULATION ';'
	| MS_SIMULATION '(' ms_simulation_options_list ')' ';'
	;

ms_estimation_option :
	o_coefficients_prior_hyperparameters
	| o_freq
	| o_initial_year
	| o_initial_subperiod
	| o_final_year
	| o_final_subperiod
	| o_datafile
	| o_xls_sheet
	| o_xls_range
	| o_nlags
	| o_cross_restrictions
	| o_contemp_reduced_form
	| o_no_bayesian_prior
	| o_alpha
	| o_beta
	| o_gsig2_lmdm
	| o_specification
	| o_output_file_tag
	| o_file_tag
	| o_no_create_init
	| o_convergence_starting_value
	| o_convergence_ending_value
	| o_convergence_increment_value
	| o_max_iterations_starting_value
	| o_max_iterations_increment_value
	| o_max_block_iterations
	| o_max_repeated_optimization_runs
	| o_function_convergence_criterion
	| o_parameter_convergence_criterion
	| o_number_of_large_perturbations
	| o_number_of_small_perturbations
	| o_number_of_posterior_draws_after_perturbation
	| o_max_number_of_stages
	| o_random_function_convergence_criterion
	| o_random_parameter_convergence_criterion
	;

ms_estimation_options_list :
	ms_estimation_option COMMA ms_estimation_options_list
	| ms_estimation_option
	;

ms_estimation :
	MS_ESTIMATION ';'
	| MS_ESTIMATION '(' ms_estimation_options_list ')' ';'
	;

dynare_sensitivity :
	DYNARE_SENSITIVITY ';'
	| DYNARE_SENSITIVITY '(' dynare_sensitivity_options_list ')' ';'
	;

dynare_sensitivity_options_list :
	dynare_sensitivity_option COMMA dynare_sensitivity_options_list
	| dynare_sensitivity_option
	;

dynare_sensitivity_option :
	o_gsa_identification
	| o_gsa_morris
	| o_gsa_stab
	| o_gsa_redform
	| o_gsa_pprior
	| o_gsa_prior_range
	| o_gsa_ppost
	| o_gsa_ilptau
	| o_gsa_morris_nliv
	| o_gsa_morris_ntra
	| o_gsa_nsam
	| o_gsa_load_redform
	| o_gsa_load_rmse
	| o_gsa_load_stab
	| o_gsa_alpha2_stab
	| o_gsa_logtrans_redform
	| o_gsa_ksstat_redform
	| o_gsa_alpha2_redform
	| o_gsa_rmse
	| o_gsa_lik_only
	| o_gsa_pfilt_rmse
	| o_gsa_istart_rmse
	| o_gsa_alpha_rmse
	| o_gsa_alpha2_rmse
	| o_gsa_threshold_redform
	| o_gsa_namendo
	| o_gsa_namexo
	| o_gsa_namlagendo
	| o_gsa_var_rmse
	| o_gsa_neighborhood_width
	| o_gsa_pvalue_ks
	| o_gsa_pvalue_corr
	| o_datafile
	| o_nobs
	| o_first_obs
	| o_prefilter
	| o_presample
	| o_nograph
	| o_nodisplay
	| o_graph_format
	| o_forecasts_conf_sig
	| o_mh_conf_sig
	| o_loglinear
	| o_mode_file
	| o_load_ident_files
	| o_useautocorr
	| o_ar
	| o_kalman_algo
	| o_lik_init
	| o_diffuse_filter
	| o_analytic_derivation
	| o_analytic_derivation_mode
	;

shock_decomposition_options_list :
	shock_decomposition_option COMMA shock_decomposition_options_list
	| shock_decomposition_option
	;

shock_decomposition_option :
	o_parameter_set
	| o_datafile
	| o_use_shock_groups
	| o_colormap
	| o_shock_decomposition_nograph
	| o_first_obs
	| o_nobs
	| o_init_state
	| o_forecast_type
	| o_shock_decomposition_with_epilogue
	| o_prefilter
	| o_loglinear
	| o_diffuse_kalman_tol
	| o_diffuse_filter
	| o_xls_sheet
	| o_xls_range
	;

realtime_shock_decomposition_options_list :
	realtime_shock_decomposition_option COMMA realtime_shock_decomposition_options_list
	| realtime_shock_decomposition_option
	;

realtime_shock_decomposition_option :
	o_parameter_set
	| o_datafile
	| o_first_obs
	| o_nobs
	| o_use_shock_groups
	| o_colormap
	| o_shock_decomposition_nograph
	| o_shock_decomposition_presample
	| o_shock_decomposition_forecast
	| o_save_realtime
	| o_fast_realtime
	| o_shock_decomposition_with_epilogue
	;

plot_shock_decomposition_options_list :
	plot_shock_decomposition_option COMMA plot_shock_decomposition_options_list
	| plot_shock_decomposition_option
	;

plot_shock_decomposition_option :
	o_use_shock_groups
	| o_colormap
	| o_psd_nodisplay
	| o_psd_graph_format
	| o_psd_detail_plot
	| o_psd_interactive
	| o_psd_screen_shocks
	| o_psd_steadystate
	| o_psd_type
	| o_psd_fig_name
	| o_psd_write_xls
	| o_psd_realtime
	| o_psd_vintage
	| o_psd_plot_init_date
	| o_psd_plot_end_date
	| o_psd_diff
	| o_psd_flip
	| o_psd_nograph
	| o_psd_init2shocks
	| o_psd_max_nrows
	;

initial_condition_decomposition_options_list :
	initial_condition_decomposition_option COMMA initial_condition_decomposition_options_list
	| initial_condition_decomposition_option
	;

initial_condition_decomposition_option :
	o_icd_type
	| o_icd_detail_plot
	| o_icd_steadystate
	| o_icd_write_xls
	| o_icd_plot_init_date
	| o_icd_plot_end_date
	| o_icd_nodisplay
	| o_icd_graph_format
	| o_icd_fig_name
	| o_icd_diff
	| o_icd_flip
	| o_icd_colormap
	| o_icd_max_nrows
	| o_icd_with_epilogue
	;

homotopy_setup :
	HOMOTOPY_SETUP ';' homotopy_list END ';'
	;

homotopy_list :
	homotopy_item
	| homotopy_list homotopy_item
	;

homotopy_item :
	symbol COMMA expression COMMA expression ';'
	| symbol COMMA expression ';'
	;

forecast :
	FORECAST ';'
	| FORECAST '(' forecast_options ')' ';'
	| FORECAST symbol_list ';'
	| FORECAST '(' forecast_options ')' symbol_list ';'
	;

forecast_options :
	forecast_option
	| forecast_options COMMA forecast_option
	;

forecast_option :
	o_periods
	| o_forecasts_conf_sig
	| o_nograph
	| o_nodisplay
	| o_graph_format
	;

conditional_forecast :
	CONDITIONAL_FORECAST '(' conditional_forecast_options ')' ';'
	;

conditional_forecast_options :
	conditional_forecast_option
	| conditional_forecast_options COMMA conditional_forecast_option
	;

conditional_forecast_option :
	o_periods
	| o_replic
	| o_conditional_forecast_conf_sig
	| o_controlled_varexo
	| o_parameter_set
	;

plot_conditional_forecast :
	PLOT_CONDITIONAL_FORECAST symbol_list ';'
	| PLOT_CONDITIONAL_FORECAST '(' PERIODS EQUAL INT_NUMBER ')' symbol_list ';'
	;

conditional_forecast_paths :
	CONDITIONAL_FORECAST_PATHS ';' conditional_forecast_paths_shock_list END ';'
	;

conditional_forecast_paths_shock_list :
	conditional_forecast_paths_shock_elem
	| conditional_forecast_paths_shock_list conditional_forecast_paths_shock_elem
	;

conditional_forecast_paths_shock_elem :
	VAR symbol ';' PERIODS period_list ';' VALUES value_list ';'
	;

steady_state_model :
	STEADY_STATE_MODEL ';' steady_state_equation_list END ';'
	;

steady_state_equation_list :
	steady_state_equation_list steady_state_equation
	| steady_state_equation
	;

steady_state_equation :
	symbol EQUAL expression ';'
	| '[' symbol_list ']' EQUAL expression ';'
	;

calib_smoother :
	CALIB_SMOOTHER ';'
	| CALIB_SMOOTHER '(' calib_smoother_options_list ')' ';'
	| CALIB_SMOOTHER symbol_list ';'
	| CALIB_SMOOTHER '(' calib_smoother_options_list ')' symbol_list ';'
	;

calib_smoother_options_list :
	calib_smoother_option COMMA calib_smoother_options_list
	| calib_smoother_option
	;

calib_smoother_option :
	o_filtered_vars
	| o_filter_step_ahead
	| o_datafile
	| o_prefilter
	| o_kalman_algo
	| o_loglinear
	| o_first_obs
	| o_filter_covariance
	| o_updated_covariance
	| o_filter_decomposition
	| o_diffuse_kalman_tol
	| o_diffuse_filter
	| o_smoothed_state_uncertainty
	| o_smoother_redux
	| o_parameter_set
	| o_xls_sheet
	| o_xls_range
	| o_heteroskedastic_filter
	| o_nobs
	;

generate_irfs :
	GENERATE_IRFS ';' END ';'
	| GENERATE_IRFS ';' generate_irfs_element_list END ';'
	| GENERATE_IRFS '(' generate_irfs_options_list ')' ';' END ';'
	| GENERATE_IRFS '(' generate_irfs_options_list ')' ';' generate_irfs_element_list END ';'
	;

generate_irfs_options_list :
	generate_irfs_option COMMA generate_irfs_options_list
	| generate_irfs_option
	;

generate_irfs_option :
	o_stderr_multiples
	| o_diagonal_only
	;

generate_irfs_element_list :
	generate_irfs_element_list generate_irfs_element
	| generate_irfs_element
	;

generate_irfs_element :
	NAME COMMA generate_irfs_exog_element_list ';'
	;

generate_irfs_exog_element_list :
	generate_irfs_exog_element_list COMMA symbol EQUAL signed_number
	| symbol EQUAL signed_number
	;

extended_path :
	EXTENDED_PATH ';'
	| EXTENDED_PATH '(' extended_path_options_list ')' ';'
	;

extended_path_options_list :
	extended_path_option COMMA extended_path_options_list
	| extended_path_option
	;

extended_path_option :
	o_periods
	| o_solver_periods
	| o_extended_path_order
	| o_hybrid
	| o_lmmcp
	;

model_diagnostics :
	MODEL_DIAGNOSTICS ';'
	;

calibration_range :
	'[' expression COMMA expression ']'
	| PLUS /*3L*/
	| MINUS /*3L*/
	;

moment_calibration :
	MOMENT_CALIBRATION ';' moment_calibration_list END ';'
	;

moment_calibration_list :
	moment_calibration_item
	| moment_calibration_list moment_calibration_item
	;

moment_calibration_item :
	symbol COMMA symbol COMMA calibration_range ';'
	| symbol COMMA symbol '(' signed_integer ')' COMMA calibration_range ';'
	| symbol COMMA symbol '(' signed_integer_range ')' COMMA calibration_range ';'
	;

irf_calibration :
	IRF_CALIBRATION ';' irf_calibration_list END ';'
	| IRF_CALIBRATION '(' o_relative_irf ')' ';' irf_calibration_list END ';'
	;

irf_calibration_list :
	irf_calibration_item
	| irf_calibration_list irf_calibration_item
	;

irf_calibration_item :
	symbol COMMA symbol COMMA calibration_range ';'
	| symbol '(' INT_NUMBER ')' COMMA symbol COMMA calibration_range ';'
	| symbol '(' integer_range ')' COMMA symbol COMMA calibration_range ';'
	;

smoother2histval :
	SMOOTHER2HISTVAL ';'
	| SMOOTHER2HISTVAL '(' smoother2histval_options_list ')' ';'
	;

smoother2histval_options_list :
	smoother2histval_option COMMA smoother2histval_options_list
	| smoother2histval_option
	;

smoother2histval_option :
	o_infile
	| o_invars
	| o_period
	| o_outfile
	| o_outvars
	;

shock_groups :
	SHOCK_GROUPS ';' shock_group_list END ';'
	| SHOCK_GROUPS '(' NAME EQUAL symbol ')' ';' shock_group_list END ';'
	;

shock_group_list :
	shock_group_list shock_group_element
	| shock_group_element
	;

shock_group_element :
	symbol EQUAL shock_name_list ';'
	| QUOTED_STRING EQUAL shock_name_list ';'
	;

shock_name_list :
	shock_name_list COMMA symbol
	| shock_name_list symbol
	| symbol
	;

init2shocks :
	INIT2SHOCKS ';' init2shocks_list END ';'
	| INIT2SHOCKS '(' NAME EQUAL symbol ')' ';' init2shocks_list END ';'
	;

init2shocks_list :
	init2shocks_list init2shocks_element
	| init2shocks_element
	;

init2shocks_element :
	symbol symbol ';'
	| symbol COMMA symbol ';'
	;

o_dr_algo :
	DR_ALGO EQUAL INT_NUMBER
	;

o_solve_algo :
	SOLVE_ALGO EQUAL INT_NUMBER
	;

o_simul_algo :
	SIMUL_ALGO EQUAL INT_NUMBER
	;

o_stack_solve_algo :
	STACK_SOLVE_ALGO EQUAL INT_NUMBER
	;

o_robust_lin_solve :
	ROBUST_LIN_SOLVE
	;

o_endogenous_terminal_period :
	ENDOGENOUS_TERMINAL_PERIOD
	;

o_linear :
	LINEAR
	;

o_order :
	ORDER EQUAL INT_NUMBER
	;

o_replic :
	REPLIC EQUAL INT_NUMBER
	;

o_drop :
	DROP EQUAL INT_NUMBER
	;

o_ar :
	AR EQUAL INT_NUMBER
	;

o_nocorr :
	NOCORR
	;

o_nofunctions :
	NOFUNCTIONS
	;

o_nomoments :
	NOMOMENTS
	;

o_irf :
	IRF EQUAL INT_NUMBER
	;

o_irf_shocks :
	IRF_SHOCKS EQUAL '(' symbol_list ')'
	;

o_hp_filter :
	HP_FILTER EQUAL non_negative_number
	;

o_hp_ngrid :
	HP_NGRID EQUAL INT_NUMBER
	;

o_filtered_theoretical_moments_grid :
	FILTERED_THEORETICAL_MOMENTS_GRID EQUAL INT_NUMBER
	;

o_one_sided_hp_filter :
	ONE_SIDED_HP_FILTER EQUAL non_negative_number
	;

o_periods :
	PERIODS EQUAL INT_NUMBER
	;

o_solver_periods :
	SOLVER_PERIODS EQUAL INT_NUMBER
	;

o_extended_path_order :
	ORDER EQUAL INT_NUMBER
	;

o_hybrid :
	HYBRID
	;

o_steady_maxit :
	MAXIT EQUAL INT_NUMBER
	;

o_simul_maxit :
	MAXIT EQUAL INT_NUMBER
	;

o_bandpass_filter :
	BANDPASS_FILTER
	| BANDPASS_FILTER EQUAL vec_int
	;

o_dp_maxit :
	MAXIT EQUAL INT_NUMBER
	;

o_osr_maxit :
	MAXIT EQUAL INT_NUMBER
	;

o_osr_tolf :
	TOLF EQUAL non_negative_number
	;

o_pf_tolf :
	TOLF EQUAL non_negative_number
	;

o_pf_tolx :
	TOLX EQUAL non_negative_number
	;

o_steady_tolf :
	TOLF EQUAL non_negative_number
	;

o_steady_tolx :
	TOLX EQUAL non_negative_number
	;

o_opt_algo :
	OPT_ALGO EQUAL INT_NUMBER
	| OPT_ALGO EQUAL filename
	;

o_cutoff :
	CUTOFF EQUAL non_negative_number
	;

o_markowitz :
	MARKOWITZ EQUAL non_negative_number
	;

o_pf_steady_solve_algo :
	STEADY_SOLVE_ALGO EQUAL INT_NUMBER
	;

o_pf_steady_maxit :
	STEADY_MAXIT EQUAL INT_NUMBER
	;

o_pf_steady_tolf :
	STEADY_TOLF EQUAL non_negative_number
	;

o_pf_steady_tolx :
	STEADY_TOLX EQUAL non_negative_number
	;

o_pf_steady_markowitz :
	STEADY_MARKOWITZ EQUAL non_negative_number
	;

o_minimal_solving_periods :
	MINIMAL_SOLVING_PERIODS EQUAL non_negative_number
	;

o_mfs :
	MFS EQUAL INT_NUMBER
	;

o_simul :
	SIMUL
	;

o_simul_replic :
	SIMUL_REPLIC EQUAL INT_NUMBER
	;

o_simul_seed :
	SIMUL_SEED EQUAL INT_NUMBER
	;

o_qz_criterium :
	QZ_CRITERIUM EQUAL non_negative_number
	;

o_qz_zero_threshold :
	QZ_ZERO_THRESHOLD EQUAL non_negative_number
	;

o_file :
	FILE EQUAL filename
	;

o_pac_name :
	MODEL_NAME EQUAL symbol
	;

o_pac_aux_model_name :
	AUXILIARY_MODEL_NAME EQUAL symbol
	;

o_pac_discount :
	DISCOUNT EQUAL symbol
	;

o_pac_growth :
	GROWTH EQUAL hand_side
	;

o_pac_auxname :
	AUXNAME EQUAL symbol
	;

o_pac_kind :
	KIND EQUAL pac_target_kind
	;

o_var_name :
	MODEL_NAME EQUAL symbol
	;

o_series :
	SERIES EQUAL symbol
	;

o_datafile :
	DATAFILE EQUAL filename
	;

o_filename :
	FILENAME EQUAL filename
	;

o_var_eq_tags :
	EQTAGS EQUAL vec_str
	;

o_var_structural :
	STRUCTURAL
	;

o_dirname :
	DIRNAME EQUAL filename
	;

o_huge_number :
	HUGE_NUMBER EQUAL non_negative_number
	;

o_nobs :
	NOBS EQUAL vec_int
	| NOBS EQUAL vec_int_number
	;

o_trend_component_model_name :
	MODEL_NAME EQUAL symbol
	;

o_trend_component_model_targets :
	TARGETS EQUAL vec_str
	;

o_trend_component_model_eq_tags :
	EQTAGS EQUAL vec_str
	;

o_conditional_variance_decomposition :
	CONDITIONAL_VARIANCE_DECOMPOSITION EQUAL vec_int
	| CONDITIONAL_VARIANCE_DECOMPOSITION EQUAL vec_int_number
	;

o_est_first_obs :
	FIRST_OBS EQUAL vec_int
	| FIRST_OBS EQUAL vec_int_number
	;

o_posterior_sampling_method :
	POSTERIOR_SAMPLING_METHOD EQUAL QUOTED_STRING
	;

o_first_obs :
	FIRST_OBS EQUAL INT_NUMBER
	;

o_data_first_obs :
	FIRST_OBS EQUAL date_expr
	;

o_first_simulation_period :
	FIRST_SIMULATION_PERIOD EQUAL INT_NUMBER
	;

o_date_first_simulation_period :
	FIRST_SIMULATION_PERIOD EQUAL date_expr
	;

o_last_simulation_period :
	LAST_SIMULATION_PERIOD EQUAL INT_NUMBER
	;

o_date_last_simulation_period :
	LAST_SIMULATION_PERIOD EQUAL date_expr
	;

o_last_obs :
	LAST_OBS EQUAL INT_NUMBER
	;

o_data_last_obs :
	LAST_OBS EQUAL date_expr
	;

o_keep_kalman_algo_if_singularity_is_detected :
	KEEP_KALMAN_ALGO_IF_SINGULARITY_IS_DETECTED
	;

o_data_nobs :
	NOBS EQUAL INT_NUMBER
	;

o_shift :
	SHIFT EQUAL signed_number
	;

o_shape :
	SHAPE EQUAL prior_distribution
	;

o_mode :
	MODE EQUAL signed_number
	;

o_mean :
	MEAN EQUAL signed_number
	;

o_mean_vec :
	MEAN EQUAL vec_value
	;

o_truncate :
	TRUNCATE EQUAL vec_value
	;

o_stdev :
	STDEV EQUAL non_negative_number
	;

o_jscale :
	JSCALE EQUAL non_negative_number
	;

o_init :
	INIT EQUAL signed_number
	;

o_bounds :
	BOUNDS EQUAL vec_value_w_inf
	;

o_domain :
	DOMAINN EQUAL vec_value
	;

o_interval :
	INTERVAL EQUAL vec_value
	;

o_variance :
	VARIANCE EQUAL expression
	;

o_variance_mat :
	VARIANCE EQUAL vec_of_vec_value
	;

o_prefilter :
	PREFILTER EQUAL INT_NUMBER
	;

o_presample :
	PRESAMPLE EQUAL INT_NUMBER
	;

o_lik_algo :
	LIK_ALGO EQUAL INT_NUMBER
	;

o_lik_init :
	LIK_INIT EQUAL INT_NUMBER
	;

o_nograph :
	NOGRAPH
	| GRAPH
	;

o_posterior_nograph :
	POSTERIOR_NOGRAPH
	| POSTERIOR_GRAPH
	;

o_psd_nograph :
	NOGRAPH
	;

o_shock_decomposition_nograph :
	NOGRAPH
	;

o_init_state :
	INIT_STATE EQUAL INT_NUMBER
	;

o_forecast_type :
	FORECAST EQUAL UNCONDITIONAL
	| FORECAST EQUAL CONDITIONAL
	;

o_shock_decomposition_presample :
	PRESAMPLE EQUAL INT_NUMBER
	;

o_shock_decomposition_forecast :
	FORECAST EQUAL INT_NUMBER
	;

o_save_realtime :
	SAVE_REALTIME EQUAL vec_int
	;

o_fast_realtime :
	FAST_REALTIME EQUAL vec_int
	| FAST_REALTIME EQUAL vec_int_number
	;

o_nodisplay :
	NODISPLAY
	;

o_icd_nodisplay :
	NODISPLAY
	;

o_psd_nodisplay :
	NODISPLAY
	;

o_psd_init2shocks :
	INIT2SHOCKS
	| INIT2SHOCKS EQUAL symbol
	;

o_icd_max_nrows :
	MAX_NROWS EQUAL INT_NUMBER
	;

o_psd_max_nrows :
	MAX_NROWS EQUAL INT_NUMBER
	;

o_graph_format :
	GRAPH_FORMAT EQUAL allowed_graph_formats
	| GRAPH_FORMAT EQUAL '(' list_allowed_graph_formats ')'
	;

o_icd_graph_format :
	GRAPH_FORMAT EQUAL allowed_graph_formats
	| GRAPH_FORMAT EQUAL '(' list_allowed_graph_formats ')'
	;

o_psd_graph_format :
	GRAPH_FORMAT EQUAL allowed_graph_formats
	| GRAPH_FORMAT EQUAL '(' list_allowed_graph_formats ')'
	;

o_shock_decomposition_with_epilogue :
	WITH_EPILOGUE
	;

o_icd_with_epilogue :
	WITH_EPILOGUE
	;

allowed_graph_formats :
	EPS
	| FIG
	| PDF
	| NONE
	;

list_allowed_graph_formats :
	allowed_graph_formats
	| list_allowed_graph_formats COMMA allowed_graph_formats
	;

o_subsample_name :
	symbol EQUAL date_expr ':' date_expr
	;

o_bvar_conf_sig :
	CONF_SIG EQUAL non_negative_number
	;

o_forecasts_conf_sig :
	CONF_SIG EQUAL non_negative_number
	;

o_conditional_forecast_conf_sig :
	CONF_SIG EQUAL non_negative_number
	;

o_mh_conf_sig :
	MH_CONF_SIG EQUAL non_negative_number
	;

o_mh_replic :
	MH_REPLIC EQUAL INT_NUMBER
	;

o_posterior_max_subsample_draws :
	POSTERIOR_MAX_SUBSAMPLE_DRAWS EQUAL INT_NUMBER
	;

o_mh_drop :
	MH_DROP EQUAL non_negative_number
	;

o_mh_jscale :
	MH_JSCALE EQUAL non_negative_number
	;

o_mh_tune_jscale :
	MH_TUNE_JSCALE EQUAL non_negative_number
	| MH_TUNE_JSCALE
	;

o_mh_tune_guess :
	MH_TUNE_GUESS EQUAL non_negative_number
	;

o_optim :
	OPTIM EQUAL '(' name_value_pair_with_boolean_list ')'
	;

o_posterior_sampler_options :
	POSTERIOR_SAMPLER_OPTIONS EQUAL '(' name_value_pair_with_suboptions_list ')'
	;

o_proposal_distribution :
	PROPOSAL_DISTRIBUTION EQUAL symbol
	;

o_no_posterior_kernel_density :
	NO_POSTERIOR_KERNEL_DENSITY
	;

o_mh_init_scale :
	MH_INIT_SCALE EQUAL non_negative_number
	;

o_mh_init_scale_factor :
	MH_INIT_SCALE_FACTOR EQUAL non_negative_number
	;

o_mode_file :
	MODE_FILE EQUAL filename
	;

o_mode_compute :
	MODE_COMPUTE EQUAL INT_NUMBER
	| MODE_COMPUTE EQUAL symbol
	;

o_mode_check :
	MODE_CHECK
	;

o_mode_check_neighbourhood_size :
	MODE_CHECK_NEIGHBOURHOOD_SIZE EQUAL signed_number_w_inf
	;

o_mode_check_number_of_points :
	MODE_CHECK_NUMBER_OF_POINTS EQUAL INT_NUMBER
	;

o_mode_check_symmetric_plots :
	MODE_CHECK_SYMMETRIC_PLOTS EQUAL INT_NUMBER
	;

o_prior_trunc :
	PRIOR_TRUNC EQUAL non_negative_number
	;

o_mh_posterior_mode_estimation :
	MH_POSTERIOR_MODE_ESTIMATION
	;

o_mh_nblocks :
	MH_NBLOCKS EQUAL INT_NUMBER
	;

o_load_mh_file :
	LOAD_MH_FILE
	;

o_load_results_after_load_mh :
	LOAD_RESULTS_AFTER_LOAD_MH
	;

o_loglinear :
	LOGLINEAR
	;

o_linear_approximation :
	LINEAR_APPROXIMATION
	;

o_logdata :
	LOGDATA
	;

o_conditional_likelihood :
	CONDITIONAL_LIKELIHOOD
	;

o_nodiagnostic :
	NODIAGNOSTIC
	;

o_bayesian_irf :
	BAYESIAN_IRF
	;

o_dsge_var :
	DSGE_VAR EQUAL non_negative_number
	| DSGE_VAR EQUAL INF_CONSTANT
	| DSGE_VAR
	;

o_dsge_varlag :
	DSGE_VARLAG EQUAL INT_NUMBER
	;

o_tex :
	TEX
	;

o_forecast :
	FORECAST EQUAL INT_NUMBER
	;

o_smoother :
	SMOOTHER
	;

o_moments_varendo :
	MOMENTS_VARENDO
	;

o_contemporaneous_correlation :
	CONTEMPORANEOUS_CORRELATION
	;

o_filtered_vars :
	FILTERED_VARS
	;

o_relative_irf :
	RELATIVE_IRF
	;

o_fast_kalman_filter :
	FAST_KALMAN_FILTER
	;

o_kalman_algo :
	KALMAN_ALGO EQUAL INT_NUMBER
	;

o_kalman_tol :
	KALMAN_TOL EQUAL non_negative_number
	;

o_diffuse_kalman_tol :
	DIFFUSE_KALMAN_TOL EQUAL non_negative_number
	;

o_schur_vec_tol :
	SCHUR_VEC_TOL EQUAL non_negative_number
	;

o_marginal_density :
	MARGINAL_DENSITY EQUAL LAPLACE
	| MARGINAL_DENSITY EQUAL MODIFIEDHARMONICMEAN
	;

o_print :
	PRINT
	;

o_noprint :
	NOPRINT
	;

o_xls_sheet :
	XLS_SHEET EQUAL symbol
	| XLS_SHEET EQUAL QUOTED_STRING
	;

o_xls_range :
	XLS_RANGE EQUAL range
	;

o_filter_step_ahead :
	FILTER_STEP_AHEAD EQUAL vec_int
	;

o_taper_steps :
	TAPER_STEPS EQUAL vec_int
	;

o_geweke_interval :
	GEWEKE_INTERVAL EQUAL vec_value
	;

o_raftery_lewis_diagnostics :
	RAFTERY_LEWIS_DIAGNOSTICS
	;

o_raftery_lewis_qrs :
	RAFTERY_LEWIS_QRS EQUAL vec_value
	;

o_brooks_gelman_plotrows :
	BROOKS_GELMAN_PLOTROWS EQUAL INT_NUMBER
	;

o_constant :
	CONSTANT
	;

o_noconstant :
	NOCONSTANT
	;

o_mh_recover :
	MH_RECOVER
	;

o_mh_initialize_from_previous_mcmc :
	MH_INITIALIZE_FROM_PREVIOUS_MCMC
	;

o_mh_initialize_from_previous_mcmc_directory :
	MH_INITIALIZE_FROM_PREVIOUS_MCMC_DIRECTORY EQUAL filename
	;

o_mh_initialize_from_previous_mcmc_record :
	MH_INITIALIZE_FROM_PREVIOUS_MCMC_RECORD EQUAL filename
	;

o_mh_initialize_from_previous_mcmc_prior :
	MH_INITIALIZE_FROM_PREVIOUS_MCMC_PRIOR EQUAL filename
	;

o_diffuse_filter :
	DIFFUSE_FILTER
	;

o_plot_priors :
	PLOT_PRIORS EQUAL INT_NUMBER
	;

o_aim_solver :
	AIM_SOLVER
	;

o_partial_information :
	PARTIAL_INFORMATION
	;

o_sub_draws :
	SUB_DRAWS EQUAL INT_NUMBER
	;

o_planner_discount :
	PLANNER_DISCOUNT EQUAL expression
	;

o_planner_discount_latex_name :
	PLANNER_DISCOUNT_LATEX_NAME EQUAL TEX_NAME
	;

o_sylvester :
	SYLVESTER EQUAL FIXED_POINT
	| SYLVESTER EQUAL DEFAULT
	;

o_sylvester_fixed_point_tol :
	SYLVESTER_FIXED_POINT_TOL EQUAL non_negative_number
	;

o_lyapunov :
	LYAPUNOV EQUAL FIXED_POINT
	| LYAPUNOV EQUAL DOUBLING
	| LYAPUNOV EQUAL SQUARE_ROOT_SOLVER
	| LYAPUNOV EQUAL DEFAULT
	;

o_lyapunov_complex_threshold :
	LYAPUNOV_COMPLEX_THRESHOLD EQUAL non_negative_number
	;

o_lyapunov_fixed_point_tol :
	LYAPUNOV_FIXED_POINT_TOL EQUAL non_negative_number
	;

o_lyapunov_doubling_tol :
	LYAPUNOV_DOUBLING_TOL EQUAL non_negative_number
	;

o_dr :
	DR EQUAL CYCLE_REDUCTION
	| DR EQUAL LOGARITHMIC_REDUCTION
	| DR EQUAL DEFAULT
	;

o_dr_cycle_reduction_tol :
	DR_CYCLE_REDUCTION_TOL EQUAL non_negative_number
	;

o_dr_logarithmic_reduction_tol :
	DR_LOGARITHMIC_REDUCTION_TOL EQUAL non_negative_number
	;

o_dr_logarithmic_reduction_maxiter :
	DR_LOGARITHMIC_REDUCTION_MAXITER EQUAL INT_NUMBER
	;

o_psd_detail_plot :
	DETAIL_PLOT
	;

o_icd_detail_plot :
	DETAIL_PLOT
	;

o_psd_interactive :
	INTERACTIVE
	;

o_psd_screen_shocks :
	SCREEN_SHOCKS
	;

o_psd_steadystate :
	STEADYSTATE
	;

o_icd_steadystate :
	STEADYSTATE
	;

o_icd_fig_name :
	FIG_NAME EQUAL filename
	;

o_psd_fig_name :
	FIG_NAME EQUAL filename
	;

o_psd_type :
	TYPE EQUAL QOQ
	| TYPE EQUAL YOY
	| TYPE EQUAL AOA
	;

o_icd_type :
	TYPE EQUAL QOQ
	| TYPE EQUAL YOY
	| TYPE EQUAL AOA
	;

o_icd_plot_init_date :
	PLOT_INIT_DATE EQUAL date_expr
	;

o_icd_plot_end_date :
	PLOT_END_DATE EQUAL date_expr
	;

o_psd_plot_init_date :
	PLOT_INIT_DATE EQUAL date_expr
	;

o_psd_plot_end_date :
	PLOT_END_DATE EQUAL date_expr
	;

o_icd_write_xls :
	WRITE_XLS
	;

o_psd_write_xls :
	WRITE_XLS
	;

o_psd_realtime :
	REALTIME EQUAL INT_NUMBER
	;

o_psd_vintage :
	VINTAGE EQUAL INT_NUMBER
	;

o_psd_diff :
	DIFF
	;

o_icd_diff :
	DIFF
	;

o_psd_flip :
	FLIP
	;

o_icd_flip :
	FLIP
	;

o_bvar_prior_tau :
	BVAR_PRIOR_TAU EQUAL signed_number
	;

o_bvar_prior_decay :
	BVAR_PRIOR_DECAY EQUAL non_negative_number
	;

o_bvar_prior_lambda :
	BVAR_PRIOR_LAMBDA EQUAL signed_number
	;

o_bvar_prior_mu :
	BVAR_PRIOR_MU EQUAL non_negative_number
	;

o_bvar_prior_omega :
	BVAR_PRIOR_OMEGA EQUAL INT_NUMBER
	;

o_bvar_prior_flat :
	BVAR_PRIOR_FLAT
	;

o_bvar_prior_train :
	BVAR_PRIOR_TRAIN EQUAL INT_NUMBER
	;

o_bvar_replic :
	BVAR_REPLIC EQUAL INT_NUMBER
	;

o_stderr_multiples :
	STDERR_MULTIPLES
	;

o_diagonal_only :
	DIAGONAL_ONLY
	;

o_number_of_particles :
	NUMBER_OF_PARTICLES EQUAL INT_NUMBER
	;

o_particle_filter_options :
	PARTICLE_FILTER_OPTIONS EQUAL '(' name_value_pair_with_boolean_list ')'
	;

o_resampling :
	RESAMPLING EQUAL SYSTEMATIC
	| RESAMPLING EQUAL NONE
	| RESAMPLING EQUAL GENERIC
	;

o_resampling_threshold :
	RESAMPLING_THRESHOLD EQUAL non_negative_number
	;

o_resampling_method :
	RESAMPLING_METHOD EQUAL KITAGAWA
	| RESAMPLING_METHOD EQUAL SMOOTH
	| RESAMPLING_METHOD EQUAL STRATIFIED
	;

o_cpf_weights :
	CPF_WEIGHTS EQUAL AMISANOTRISTANI
	| CPF_WEIGHTS EQUAL MURRAYJONESPARSLOW
	;

o_filter_algorithm :
	FILTER_ALGORITHM EQUAL symbol
	;

o_nonlinear_filter_initialization :
	NONLINEAR_FILTER_INITIALIZATION EQUAL INT_NUMBER
	;

o_proposal_approximation :
	PROPOSAL_APPROXIMATION EQUAL CUBATURE
	| PROPOSAL_APPROXIMATION EQUAL UNSCENTED
	| PROPOSAL_APPROXIMATION EQUAL MONTECARLO
	;

o_distribution_approximation :
	DISTRIBUTION_APPROXIMATION EQUAL CUBATURE
	| DISTRIBUTION_APPROXIMATION EQUAL UNSCENTED
	| DISTRIBUTION_APPROXIMATION EQUAL MONTECARLO
	;

o_gsa_identification :
	IDENTIFICATION EQUAL INT_NUMBER
	;

o_gsa_morris :
	MORRIS EQUAL INT_NUMBER
	;

o_gsa_stab :
	STAB EQUAL INT_NUMBER
	;

o_gsa_redform :
	REDFORM EQUAL INT_NUMBER
	;

o_gsa_pprior :
	PPRIOR EQUAL INT_NUMBER
	;

o_gsa_prior_range :
	PRIOR_RANGE EQUAL INT_NUMBER
	;

o_gsa_ppost :
	PPOST EQUAL INT_NUMBER
	;

o_gsa_ilptau :
	ILPTAU EQUAL INT_NUMBER
	;

o_gsa_morris_nliv :
	MORRIS_NLIV EQUAL INT_NUMBER
	;

o_gsa_morris_ntra :
	MORRIS_NTRA EQUAL INT_NUMBER
	;

o_gsa_nsam :
	NSAM EQUAL INT_NUMBER
	;

o_gsa_load_redform :
	LOAD_REDFORM EQUAL INT_NUMBER
	;

o_gsa_load_rmse :
	LOAD_RMSE EQUAL INT_NUMBER
	;

o_gsa_load_stab :
	LOAD_STAB EQUAL INT_NUMBER
	;

o_gsa_alpha2_stab :
	ALPHA2_STAB EQUAL non_negative_number
	;

o_gsa_logtrans_redform :
	LOGTRANS_REDFORM EQUAL INT_NUMBER
	;

o_gsa_threshold_redform :
	THRESHOLD_REDFORM EQUAL vec_value_w_inf
	;

o_gsa_ksstat_redform :
	KSSTAT_REDFORM EQUAL non_negative_number
	;

o_gsa_alpha2_redform :
	ALPHA2_REDFORM EQUAL non_negative_number
	;

o_gsa_namendo :
	NAMENDO EQUAL '(' symbol_list_or_wildcard ')'
	;

o_gsa_namlagendo :
	NAMLAGENDO EQUAL '(' symbol_list_or_wildcard ')'
	;

o_gsa_namexo :
	NAMEXO EQUAL '(' symbol_list_or_wildcard ')'
	;

o_gsa_rmse :
	RMSE EQUAL INT_NUMBER
	;

o_gsa_lik_only :
	LIK_ONLY EQUAL INT_NUMBER
	;

o_gsa_var_rmse :
	VAR_RMSE EQUAL '(' symbol_list_or_wildcard ')'
	;

o_gsa_pfilt_rmse :
	PFILT_RMSE EQUAL non_negative_number
	;

o_gsa_istart_rmse :
	ISTART_RMSE EQUAL INT_NUMBER
	;

o_gsa_alpha_rmse :
	ALPHA_RMSE EQUAL non_negative_number
	;

o_gsa_alpha2_rmse :
	ALPHA2_RMSE EQUAL non_negative_number
	;

o_gsa_sample_file :
	GSA_SAMPLE_FILE EQUAL INT_NUMBER
	| GSA_SAMPLE_FILE EQUAL filename
	;

o_gsa_neighborhood_width :
	NEIGHBORHOOD_WIDTH EQUAL non_negative_number
	;

o_gsa_pvalue_ks :
	PVALUE_KS EQUAL non_negative_number
	;

o_gsa_pvalue_corr :
	PVALUE_CORR EQUAL non_negative_number
	;

o_load_ident_files :
	LOAD_IDENT_FILES EQUAL INT_NUMBER
	;

o_useautocorr :
	USEAUTOCORR EQUAL INT_NUMBER
	;

o_prior_mc :
	PRIOR_MC EQUAL INT_NUMBER
	;

o_advanced :
	ADVANCED EQUAL signed_integer
	;

o_max_dim_cova_group :
	MAX_DIM_COVA_GROUP EQUAL INT_NUMBER
	;

o_homotopy_mode :
	HOMOTOPY_MODE EQUAL INT_NUMBER
	;

o_homotopy_steps :
	HOMOTOPY_STEPS EQUAL INT_NUMBER
	;

o_homotopy_force_continue :
	HOMOTOPY_FORCE_CONTINUE EQUAL INT_NUMBER
	;

o_nocheck :
	NOCHECK
	;

o_controlled_varexo :
	CONTROLLED_VAREXO EQUAL '(' symbol_list ')'
	;

o_parameter_set :
	PARAMETER_SET EQUAL PRIOR_MODE
	| PARAMETER_SET EQUAL PRIOR_MEAN
	| PARAMETER_SET EQUAL POSTERIOR_MEAN
	| PARAMETER_SET EQUAL POSTERIOR_MODE
	| PARAMETER_SET EQUAL POSTERIOR_MEDIAN
	| PARAMETER_SET EQUAL MLE_MODE
	| PARAMETER_SET EQUAL CALIBRATION
	;

o_nodecomposition :
	NODECOMPOSITION
	;

o_spectral_density :
	SPECTRAL_DENSITY
	;

o_ms_drop :
	DROP EQUAL INT_NUMBER
	;

o_ms_mh_replic :
	MH_REPLIC EQUAL INT_NUMBER
	;

o_freq :
	FREQ EQUAL INT_NUMBER
	| FREQ EQUAL MONTHLY
	| FREQ EQUAL QUARTERLY
	;

o_initial_year :
	INITIAL_YEAR EQUAL INT_NUMBER
	;

o_initial_subperiod :
	INITIAL_SUBPERIOD EQUAL INT_NUMBER
	;

o_final_year :
	FINAL_YEAR EQUAL INT_NUMBER
	;

o_final_subperiod :
	FINAL_SUBPERIOD EQUAL INT_NUMBER
	;

o_data :
	DATA EQUAL filename
	;

o_vlist :
	VLIST EQUAL INT_NUMBER
	;

o_vlistlog :
	VLISTLOG EQUAL '(' symbol_list ')'
	;

o_vlistper :
	VLISTPER EQUAL INT_NUMBER
	;

o_restriction_fname :
	RESTRICTION_FNAME EQUAL NAME
	| RESTRICTION_FNAME EQUAL UPPER_CHOLESKY
	| RESTRICTION_FNAME EQUAL LOWER_CHOLESKY
	;

o_nlags :
	NLAGS EQUAL INT_NUMBER
	;

o_cross_restrictions :
	CROSS_RESTRICTIONS
	;

o_contemp_reduced_form :
	CONTEMP_REDUCED_FORM
	;

o_real_pseudo_forecast :
	REAL_PSEUDO_FORECAST EQUAL INT_NUMBER
	;

o_no_bayesian_prior :
	NO_BAYESIAN_PRIOR
	;

o_dummy_obs :
	DUMMY_OBS EQUAL INT_NUMBER
	;

o_nstates :
	NSTATES EQUAL INT_NUMBER
	;

o_indxscalesstates :
	INDXSCALESSTATES EQUAL INT_NUMBER
	;

o_alpha :
	ALPHA EQUAL non_negative_number
	;

o_beta :
	BETA EQUAL non_negative_number
	;

o_gsig2_lmdm :
	GSIG2_LMDM EQUAL INT_NUMBER
	;

o_specification :
	SPECIFICATION EQUAL SIMS_ZHA
	| SPECIFICATION EQUAL NONE
	;

o_q_diag :
	Q_DIAG EQUAL non_negative_number
	;

o_flat_prior :
	FLAT_PRIOR EQUAL INT_NUMBER
	;

o_ncsk :
	NCSK EQUAL INT_NUMBER
	;

o_nstd :
	NSTD EQUAL INT_NUMBER
	;

o_ninv :
	NINV EQUAL INT_NUMBER
	;

o_indxparr :
	INDXPARR EQUAL INT_NUMBER
	;

o_indxovr :
	INDXOVR EQUAL INT_NUMBER
	;

o_aband :
	ABAND EQUAL INT_NUMBER
	;

o_indxap :
	INDXAP EQUAL INT_NUMBER
	;

o_apband :
	APBAND EQUAL INT_NUMBER
	;

o_indximf :
	INDXIMF EQUAL INT_NUMBER
	;

o_indxfore :
	INDXFORE EQUAL INT_NUMBER
	;

o_foreband :
	FOREBAND EQUAL INT_NUMBER
	;

o_indxgforhat :
	INDXGFOREHAT EQUAL INT_NUMBER
	;

o_indxgimfhat :
	INDXGIMFHAT EQUAL INT_NUMBER
	;

o_indxestima :
	INDXESTIMA EQUAL INT_NUMBER
	;

o_indxgdls :
	INDXGDLS EQUAL INT_NUMBER
	;

o_eq_ms :
	EQ_MS EQUAL INT_NUMBER
	;

o_cms :
	CMS EQUAL INT_NUMBER
	;

o_ncms :
	NCMS EQUAL INT_NUMBER
	;

o_eq_cms :
	EQ_CMS EQUAL INT_NUMBER
	;

o_tlindx :
	TLINDX EQUAL INT_NUMBER
	;

o_tlnumber :
	TLNUMBER EQUAL INT_NUMBER
	;

o_cnum :
	CNUM EQUAL INT_NUMBER
	;

o_k_order_solver :
	K_ORDER_SOLVER
	;

o_pruning :
	PRUNING
	;

o_chain :
	CHAIN EQUAL INT_NUMBER
	;

o_restrictions :
	RESTRICTIONS EQUAL vec_of_vec_value
	;

o_duration :
	DURATION EQUAL non_negative_number
	| DURATION EQUAL vec_value_w_inf
	;

o_number_of_regimes :
	NUMBER_OF_REGIMES EQUAL INT_NUMBER
	;

o_number_of_lags :
	NUMBER_OF_LAGS EQUAL INT_NUMBER
	;

o_parameters :
	PARAMETERS EQUAL '[' symbol_list ']'
	;

o_coefficients :
	COEFFICIENTS
	;

o_variances :
	VARIANCES
	;

o_equations :
	EQUATIONS EQUAL vec_int
	| EQUATIONS EQUAL vec_int_number
	;

o_silent_optimizer :
	SILENT_OPTIMIZER
	;

o_instruments :
	INSTRUMENTS EQUAL '(' symbol_list ')'
	;

o_ext_func_name :
	EXT_FUNC_NAME EQUAL namespace_qualified_filename
	;

o_ext_func_nargs :
	EXT_FUNC_NARGS EQUAL INT_NUMBER
	;

o_first_deriv_provided :
	FIRST_DERIV_PROVIDED EQUAL namespace_qualified_filename
	| FIRST_DERIV_PROVIDED
	;

o_second_deriv_provided :
	SECOND_DERIV_PROVIDED EQUAL namespace_qualified_filename
	| SECOND_DERIV_PROVIDED
	;

o_filter_covariance :
	FILTER_COVARIANCE
	;

o_updated_covariance :
	UPDATED_COVARIANCE
	;

o_filter_decomposition :
	FILTER_DECOMPOSITION
	;

o_smoothed_state_uncertainty :
	SMOOTHED_STATE_UNCERTAINTY
	;

o_smoother_redux :
	SMOOTHER_REDUX
	;

o_selected_variables_only :
	SELECTED_VARIABLES_ONLY
	;

o_cova_compute :
	COVA_COMPUTE EQUAL INT_NUMBER
	;

o_output_file_tag :
	OUTPUT_FILE_TAG EQUAL filename
	;

o_file_tag :
	FILE_TAG EQUAL filename
	;

o_no_create_init :
	NO_CREATE_INIT
	;

o_simulation_file_tag :
	SIMULATION_FILE_TAG EQUAL filename
	;

o_coefficients_prior_hyperparameters :
	COEFFICIENTS_PRIOR_HYPERPARAMETERS EQUAL vec_value
	;

o_convergence_starting_value :
	CONVERGENCE_STARTING_VALUE EQUAL non_negative_number
	;

o_convergence_ending_value :
	CONVERGENCE_ENDING_VALUE EQUAL non_negative_number
	;

o_convergence_increment_value :
	CONVERGENCE_INCREMENT_VALUE EQUAL non_negative_number
	;

o_max_iterations_starting_value :
	MAX_ITERATIONS_STARTING_VALUE EQUAL INT_NUMBER
	;

o_max_iterations_increment_value :
	MAX_ITERATIONS_INCREMENT_VALUE EQUAL non_negative_number
	;

o_max_block_iterations :
	MAX_BLOCK_ITERATIONS EQUAL INT_NUMBER
	;

o_max_repeated_optimization_runs :
	MAX_REPEATED_OPTIMIZATION_RUNS EQUAL INT_NUMBER
	;

o_function_convergence_criterion :
	FUNCTION_CONVERGENCE_CRITERION EQUAL non_negative_number
	;

o_parameter_convergence_criterion :
	PARAMETER_CONVERGENCE_CRITERION EQUAL non_negative_number
	;

o_number_of_large_perturbations :
	NUMBER_OF_LARGE_PERTURBATIONS EQUAL INT_NUMBER
	;

o_number_of_small_perturbations :
	NUMBER_OF_SMALL_PERTURBATIONS EQUAL INT_NUMBER
	;

o_number_of_posterior_draws_after_perturbation :
	NUMBER_OF_POSTERIOR_DRAWS_AFTER_PERTURBATION EQUAL INT_NUMBER
	;

o_max_number_of_stages :
	MAX_NUMBER_OF_STAGES EQUAL INT_NUMBER
	;

o_random_function_convergence_criterion :
	RANDOM_FUNCTION_CONVERGENCE_CRITERION EQUAL non_negative_number
	;

o_random_parameter_convergence_criterion :
	RANDOM_PARAMETER_CONVERGENCE_CRITERION EQUAL non_negative_number
	;

o_thinning_factor :
	THINNING_FACTOR EQUAL INT_NUMBER
	;

o_adaptive_mh_draws :
	ADAPTIVE_MH_DRAWS EQUAL INT_NUMBER
	;

o_save_draws :
	SAVE_DRAWS
	;

o_proposal_draws :
	PROPOSAL_DRAWS EQUAL INT_NUMBER
	;

o_use_mean_center :
	USE_MEAN_CENTER
	;

o_proposal_type :
	PROPOSAL_TYPE EQUAL INT_NUMBER
	;

o_proposal_lower_bound :
	PROPOSAL_LOWER_BOUND EQUAL signed_number
	;

o_proposal_upper_bound :
	PROPOSAL_UPPER_BOUND EQUAL signed_number
	;

o_parameter_uncertainty :
	PARAMETER_UNCERTAINTY
	;

o_horizon :
	HORIZON EQUAL INT_NUMBER
	;

o_filtered_probabilities :
	FILTERED_PROBABILITIES
	;

o_real_time_smoothed :
	REAL_TIME_SMOOTHED
	;

o_no_error_bands :
	NO_ERROR_BANDS
	;

o_error_band_percentiles :
	ERROR_BAND_PERCENTILES EQUAL vec_value
	;

o_shock_draws :
	SHOCK_DRAWS EQUAL INT_NUMBER
	;

o_shocks_per_parameter :
	SHOCKS_PER_PARAMETER EQUAL INT_NUMBER
	;

o_free_parameters :
	FREE_PARAMETERS EQUAL vec_value
	;

o_median :
	MEDIAN
	| MEDIAN EQUAL signed_number
	;

o_regimes :
	REGIMES
	;

o_regime :
	REGIME EQUAL INT_NUMBER
	;

o_data_obs_nbr :
	DATA_OBS_NBR EQUAL INT_NUMBER
	;

o_discretionary_tol :
	DISCRETIONARY_TOL EQUAL non_negative_number
	;

o_analytic_derivation :
	ANALYTIC_DERIVATION
	;

o_analytic_derivation_mode :
	ANALYTIC_DERIVATION_MODE EQUAL signed_number
	;

o_endogenous_prior :
	ENDOGENOUS_PRIOR
	;

o_use_univariate_filters_if_singularity_is_detected :
	USE_UNIVARIATE_FILTERS_IF_SINGULARITY_IS_DETECTED EQUAL INT_NUMBER
	;

o_mcmc_jumping_covariance :
	MCMC_JUMPING_COVARIANCE EQUAL HESSIAN
	| MCMC_JUMPING_COVARIANCE EQUAL PRIOR_VARIANCE
	| MCMC_JUMPING_COVARIANCE EQUAL IDENTITY_MATRIX
	| MCMC_JUMPING_COVARIANCE EQUAL filename
	;

o_rescale_prediction_error_covariance :
	RESCALE_PREDICTION_ERROR_COVARIANCE
	;

o_use_penalized_objective_for_hessian :
	USE_PENALIZED_OBJECTIVE_FOR_HESSIAN
	;

o_irf_plot_threshold :
	IRF_PLOT_THRESHOLD EQUAL non_negative_number
	;

o_dr_display_tol :
	DR_DISPLAY_TOL EQUAL non_negative_number
	;

o_consider_all_endogenous :
	CONSIDER_ALL_ENDOGENOUS
	;

o_consider_all_endogenous_and_auxiliary :
	CONSIDER_ALL_ENDOGENOUS_AND_AUXILIARY
	;

o_consider_only_observed :
	CONSIDER_ONLY_OBSERVED
	;

o_no_homotopy :
	NO_HOMOTOPY
	;

o_endval_steady :
	ENDVAL_STEADY
	;

o_homotopy_max_completion_share :
	HOMOTOPY_MAX_COMPLETION_SHARE EQUAL non_negative_number
	;

o_homotopy_min_step_size :
	HOMOTOPY_MIN_STEP_SIZE EQUAL non_negative_number
	;

o_homotopy_initial_step_size :
	HOMOTOPY_INITIAL_STEP_SIZE EQUAL non_negative_number
	;

o_homotopy_step_size_increase_success_count :
	HOMOTOPY_STEP_SIZE_INCREASE_SUCCESS_COUNT EQUAL INT_NUMBER
	;

o_homotopy_linearization_fallback :
	HOMOTOPY_LINEARIZATION_FALLBACK
	;

o_homotopy_marginal_linearization_fallback :
	HOMOTOPY_MARGINAL_LINEARIZATION_FALLBACK
	| HOMOTOPY_MARGINAL_LINEARIZATION_FALLBACK EQUAL non_negative_number
	;

o_infile :
	INFILE EQUAL filename
	;

o_invars :
	INVARS EQUAL '(' symbol_list ')'
	;

o_period :
	PERIOD EQUAL INT_NUMBER
	;

o_outfile :
	OUTFILE EQUAL filename
	;

o_outvars :
	OUTVARS EQUAL '(' symbol_list ')'
	;

o_lmmcp :
	LMMCP
	;

o_function :
	FUNCTION EQUAL filename
	;

o_sampling_draws :
	SAMPLING_DRAWS EQUAL INT_NUMBER
	;

o_use_shock_groups :
	USE_SHOCK_GROUPS
	| USE_SHOCK_GROUPS EQUAL symbol
	;

o_colormap :
	COLORMAP EQUAL symbol
	;

o_icd_colormap :
	COLORMAP EQUAL symbol
	;

o_no_init_estimation_check_first_obs :
	NO_INIT_ESTIMATION_CHECK_FIRST_OBS
	;

o_heteroskedastic_filter :
	HETEROSKEDASTIC_FILTER
	;

o_pfwee_constant_simulation_length :
	CONSTANT_SIMULATION_LENGTH
	;

o_fsolve_options :
	FSOLVE_OPTIONS EQUAL '(' name_value_pair_with_boolean_list ')'
	;

o_bartlett_kernel_lag :
	BARTLETT_KERNEL_LAG EQUAL INT_NUMBER
	;

o_weighting_matrix :
	WEIGHTING_MATRIX EQUAL vec_str
	;

o_weighting_matrix_scaling_factor :
	WEIGHTING_MATRIX_SCALING_FACTOR EQUAL non_negative_number
	;

o_analytic_standard_errors :
	ANALYTIC_STANDARD_ERRORS
	;

o_analytic_jacobian :
	ANALYTIC_JACOBIAN
	;

o_mom_method :
	MOM_METHOD EQUAL GMM
	| MOM_METHOD EQUAL SMM
	;

o_penalized_estimator :
	PENALIZED_ESTIMATOR
	;

o_verbose :
	VERBOSE
	;

o_simulation_multiple :
	SIMULATION_MULTIPLE EQUAL INT_NUMBER
	;

o_mom_burnin :
	BURNIN EQUAL INT_NUMBER
	;

o_bounded_shock_support :
	BOUNDED_SHOCK_SUPPORT
	;

o_mom_seed :
	SEED EQUAL INT_NUMBER
	;

o_additional_optimizer_steps :
	ADDITIONAL_OPTIMIZER_STEPS EQUAL vec_int
	;

o_mom_se_tolx :
	SE_TOLX EQUAL non_negative_number
	;

o_analytical_girf :
	ANALYTICAL_GIRF
	;

o_irf_in_percent :
	IRF_IN_PERCENT
	;

o_emas_girf :
	EMAS_GIRF
	;

o_emas_drop :
	EMAS_DROP EQUAL INT_NUMBER
	;

o_emas_tolf :
	EMAS_TOLF EQUAL non_negative_number
	;

o_emas_max_iter :
	EMAS_MAX_ITER EQUAL INT_NUMBER
	;

o_non_zero :
	NON_ZERO
	;

o_no_identification_strength :
	NO_IDENTIFICATION_STRENGTH
	;

o_no_identification_reducedform :
	NO_IDENTIFICATION_REDUCEDFORM
	;

o_no_identification_moments :
	NO_IDENTIFICATION_MOMENTS
	;

o_no_identification_minimal :
	NO_IDENTIFICATION_MINIMAL
	;

o_no_identification_spectrum :
	NO_IDENTIFICATION_SPECTRUM
	;

o_normalize_jacobians :
	NORMALIZE_JACOBIANS EQUAL INT_NUMBER
	;

o_grid_nbr :
	GRID_NBR EQUAL INT_NUMBER
	;

o_tol_rank :
	TOL_RANK EQUAL non_negative_number
	;

o_tol_deriv :
	TOL_DERIV EQUAL non_negative_number
	;

o_tol_sv :
	TOL_SV EQUAL non_negative_number
	;

o_checks_via_subsets :
	CHECKS_VIA_SUBSETS EQUAL INT_NUMBER
	;

o_max_dim_subsets_groups :
	MAX_DIM_SUBSETS_GROUPS EQUAL INT_NUMBER
	;

o_zero_moments_tolerance :
	ZERO_MOMENTS_TOLERANCE EQUAL non_negative_number
	;

o_block_static :
	BLOCK_STATIC
	;

o_block_dynamic :
	BLOCK_DYNAMIC
	;

o_incidence :
	INCIDENCE
	;

o_evaluate_planner_objective_periods :
	PERIODS EQUAL INT_NUMBER
	;

o_evaluate_planner_objective_drop :
	DROP EQUAL INT_NUMBER
	;

o_occbin_simul_maxit :
	SIMUL_MAXIT EQUAL INT_NUMBER
	;

o_occbin_simul_periods :
	SIMUL_PERIODS EQUAL INT_NUMBER
	;

o_occbin_simul_curb_retrench :
	SIMUL_CURB_RETRENCH
	;

o_occbin_simul_check_ahead_periods :
	SIMUL_CHECK_AHEAD_PERIODS EQUAL INT_NUMBER
	;

o_occbin_simul_max_check_ahead_periods :
	SIMUL_MAX_CHECK_AHEAD_PERIODS EQUAL INT_NUMBER
	;

o_occbin_simul_reset_check_ahead_periods :
	SIMUL_RESET_CHECK_AHEAD_PERIODS
	;

o_occbin_simul_debug :
	SIMUL_DEBUG
	;

o_occbin_simul_periodic_solution :
	SIMUL_PERIODIC_SOLUTION
	;

o_occbin_likelihood_inversion_filter :
	LIKELIHOOD_INVERSION_FILTER
	;

o_occbin_likelihood_piecewise_kalman_filter :
	LIKELIHOOD_PIECEWISE_KALMAN_FILTER
	;

o_occbin_likelihood_maxit :
	LIKELIHOOD_MAXIT EQUAL INT_NUMBER
	;

o_occbin_likelihood_periods :
	LIKELIHOOD_PERIODS EQUAL INT_NUMBER
	;

o_occbin_likelihood_curb_retrench :
	LIKELIHOOD_CURB_RETRENCH
	;

o_occbin_likelihood_check_ahead_periods :
	LIKELIHOOD_CHECK_AHEAD_PERIODS EQUAL INT_NUMBER
	;

o_occbin_likelihood_max_check_ahead_periods :
	LIKELIHOOD_MAX_CHECK_AHEAD_PERIODS EQUAL INT_NUMBER
	;

o_occbin_likelihood_periodic_solution :
	LIKELIHOOD_PERIODIC_SOLUTION
	;

o_occbin_likelihood_max_kalman_iterations :
	LIKELIHOOD_MAX_KALMAN_ITERATIONS EQUAL INT_NUMBER
	;

o_occbin_smoother_inversion_filter :
	SMOOTHER_INVERSION_FILTER
	;

o_occbin_smoother_piecewise_kalman_filter :
	SMOOTHER_PIECEWISE_KALMAN_FILTER
	;

o_occbin_smoother_maxit :
	SMOOTHER_MAXIT EQUAL INT_NUMBER
	;

o_occbin_smoother_periods :
	SMOOTHER_PERIODS EQUAL INT_NUMBER
	;

o_occbin_smoother_curb_retrench :
	SMOOTHER_CURB_RETRENCH
	;

o_occbin_smoother_check_ahead_periods :
	SMOOTHER_CHECK_AHEAD_PERIODS EQUAL INT_NUMBER
	;

o_occbin_smoother_max_check_ahead_periods :
	SMOOTHER_MAX_CHECK_AHEAD_PERIODS EQUAL INT_NUMBER
	;

o_occbin_smoother_debug :
	SMOOTHER_DEBUG
	;

o_occbin_smoother_periodic_solution :
	SMOOTHER_PERIODIC_SOLUTION
	;

o_occbin_filter_use_relaxation :
	FILTER_USE_RELEXATION
	;

o_occbin_write_regimes_periods :
	PERIODS EQUAL vec_int
	| PERIODS EQUAL vec_int_number
	;

o_occbin_write_regimes_filename :
	FILENAME EQUAL filename
	;

o_occbin_write_regimes_smoother :
	SMOOTHER
	;

o_occbin_write_regimes_simul :
	SIMUL
	;

o_occbin_graph_noconstant :
	NOCONSTANT
	;

range :
	symbol ':' symbol
	;

integer_range :
	INT_NUMBER ':' INT_NUMBER
	;

integer_range_w_inf :
	INT_NUMBER ':' INT_NUMBER
	| INT_NUMBER ':' INF_CONSTANT
	;

signed_integer_range :
	signed_integer ':' signed_integer
	| MINUS /*3L*/ '(' signed_integer ':' signed_integer ')'
	;

vec_int_number :
	INT_NUMBER
	;

vec_int_elem :
	vec_int_number
	| INT_NUMBER ':' INT_NUMBER
	;

vec_int_1 :
	'[' vec_int_elem
	| '[' COMMA vec_int_elem
	| vec_int_1 vec_int_elem
	| vec_int_1 COMMA vec_int_elem
	;

vec_int :
	vec_int_1 ']'
	| vec_int_1 COMMA ']'
	;

vec_str_1 :
	'[' QUOTED_STRING
	| '[' COMMA QUOTED_STRING
	| vec_str_1 QUOTED_STRING
	| vec_str_1 COMMA QUOTED_STRING
	;

vec_str :
	vec_str_1 ']'
	| vec_str_1 COMMA ']'
	;

vec_value_1 :
	'[' signed_number
	| '[' COMMA signed_number
	| vec_value_1 signed_number
	| vec_value_1 COMMA signed_number
	;

vec_value :
	vec_value_1 ']'
	| vec_value_1 COMMA ']'
	;

vec_value_w_inf_1 :
	signed_number_w_inf
	| vec_value_w_inf_1 signed_number_w_inf
	| vec_value_w_inf_1 COMMA signed_number_w_inf
	;

vec_value_w_inf :
	'[' vec_value_w_inf_1 ']'
	;

vec_of_vec_value_1 :
	vec_of_vec_value_1 COMMA vec_value
	| vec_value
	;

vec_of_vec_value :
	'[' vec_of_vec_value_1 ']'
	;

symbol :
	NAME
	| ALPHA
	| BETA
	| NINV
	| ABAND
	| CMS
	| NCMS
	| CNUM
	| GAMMA
	| INV_GAMMA
	| INV_GAMMA1
	| INV_GAMMA2
	| NORMAL
	| UNIFORM
	| EPS
	| PDF
	| FIG
	| NONE
	| DR
	| PRIOR
	| TRUE
	| FALSE
	| BIND
	| RELAX
	| ERROR_BIND
	| ERROR_RELAX
	| KIND
	| LL
	| DL
	| DD
	| ADD
	| MULTIPLY
	;

%%

%option caseless

 /* NB: if new start conditions are defined, add them in the line for <<EOF>> */
%x COMMENT
%x DYNARE_STATEMENT
%x DYNARE_BLOCK
%x VERBATIM_BLOCK
%x NATIVE
%x NATIVE_COMMENT
%x DATES_STATEMENT
%x LINE1
%x LINE2
%x LINE3

DATE -?[0-9]+([ya]|m([1-9]|1[0-2])|q[1-4])

%%

 /* Rules for matching $line directives */
/*
<*>^@#line\ \"<LINE1>
<LINE1>[^\"]+<LINE2>
<LINE2>\"<>LINE3>
<LINE3>[0-9]+<<>
*/
<*>"@#".*  skip()

/* spaces, tabs and carriage returns are ignored */
<INITIAL,DYNARE_STATEMENT,DYNARE_BLOCK,COMMENT,DATES_STATEMENT,LINE1,LINE2,LINE3>[[:space:]]+  skip()

 /* Comments */
<INITIAL,DYNARE_STATEMENT,DYNARE_BLOCK,DATES_STATEMENT>%.*	skip()
<INITIAL,DYNARE_STATEMENT,DYNARE_BLOCK,DATES_STATEMENT>"//".*	skip()
<INITIAL,DYNARE_STATEMENT,DYNARE_BLOCK,DATES_STATEMENT>"/*"<>COMMENT>

<COMMENT>"*/"<<>        skip()
<COMMENT>(?s:.)<.>

<*>"("	'('
<*>")"	')'

 /* Begin of a Dynare statement */
<INITIAL>var<DYNARE_STATEMENT> VAR
<INITIAL>varexo<DYNARE_STATEMENT> VAREXO
<INITIAL>varexo_det<DYNARE_STATEMENT> VAREXO_DET
<INITIAL>trend_var<DYNARE_STATEMENT> TREND_VAR
<INITIAL>log_trend_var<DYNARE_STATEMENT> LOG_TREND_VAR
<INITIAL>predetermined_variables<DYNARE_STATEMENT> PREDETERMINED_VARIABLES
<INITIAL>parameters<DYNARE_STATEMENT> PARAMETERS
<INITIAL>model_local_variable<DYNARE_STATEMENT> MODEL_LOCAL_VARIABLE
<INITIAL>model_info<DYNARE_STATEMENT> MODEL_INFO
<INITIAL>estimation<DYNARE_STATEMENT> ESTIMATION
<INITIAL>set_time<DYNARE_STATEMENT> SET_TIME
<INITIAL>data<DYNARE_STATEMENT> DATA
<INITIAL>varobs<DYNARE_STATEMENT> VAROBS
<INITIAL>varexobs<DYNARE_STATEMENT> VAREXOBS
<INITIAL>unit_root_vars<DYNARE_STATEMENT> UNIT_ROOT_VARS
<INITIAL>rplot<DYNARE_STATEMENT> RPLOT
<INITIAL>osr_params<DYNARE_STATEMENT> OSR_PARAMS
<INITIAL>osr<DYNARE_STATEMENT> OSR
<INITIAL>dynatype<DYNARE_STATEMENT> DYNATYPE
<INITIAL>dynasave<DYNARE_STATEMENT> DYNASAVE
<INITIAL>model_comparison<DYNARE_STATEMENT> MODEL_COMPARISON
<INITIAL>change_type<DYNARE_STATEMENT> CHANGE_TYPE
<INITIAL>load_params_and_steady_state<DYNARE_STATEMENT> LOAD_PARAMS_AND_STEADY_STATE
<INITIAL>save_params_and_steady_state<DYNARE_STATEMENT> SAVE_PARAMS_AND_STEADY_STATE
<INITIAL>write_latex_dynamic_model<DYNARE_STATEMENT> WRITE_LATEX_DYNAMIC_MODEL
<INITIAL>write_latex_static_model<DYNARE_STATEMENT> WRITE_LATEX_STATIC_MODEL
<INITIAL>write_latex_original_model<DYNARE_STATEMENT> WRITE_LATEX_ORIGINAL_MODEL
<INITIAL>write_latex_steady_state_model<DYNARE_STATEMENT> WRITE_LATEX_STEADY_STATE_MODEL

<INITIAL>steady<DYNARE_STATEMENT> STEADY
<INITIAL>check<DYNARE_STATEMENT> CHECK
<INITIAL>simul<DYNARE_STATEMENT> SIMUL
<INITIAL>stoch_simul<DYNARE_STATEMENT> STOCH_SIMUL
<INITIAL>var_model<DYNARE_STATEMENT> VAR_MODEL
<INITIAL>trend_component_model<DYNARE_STATEMENT> TREND_COMPONENT_MODEL
<INITIAL>var_expectation_model<DYNARE_STATEMENT> VAR_EXPECTATION_MODEL
<INITIAL>pac_model<DYNARE_STATEMENT> PAC_MODEL
<INITIAL>dsample<DYNARE_STATEMENT> DSAMPLE
<INITIAL>planner_objective<DYNARE_STATEMENT> PLANNER_OBJECTIVE
<INITIAL>ramsey_model<DYNARE_STATEMENT> RAMSEY_MODEL
<INITIAL>ramsey_policy<DYNARE_STATEMENT> RAMSEY_POLICY
<INITIAL>evaluate_planner_objective<DYNARE_STATEMENT> EVALUATE_PLANNER_OBJECTIVE
<INITIAL>occbin_setup<DYNARE_STATEMENT> OCCBIN_SETUP
<INITIAL>occbin_solver<DYNARE_STATEMENT> OCCBIN_SOLVER
<INITIAL>occbin_write_regimes<DYNARE_STATEMENT> OCCBIN_WRITE_REGIMES
<INITIAL>occbin_graph<DYNARE_STATEMENT> OCCBIN_GRAPH
<INITIAL>discretionary_policy<DYNARE_STATEMENT> DISCRETIONARY_POLICY
<INITIAL>identification<DYNARE_STATEMENT> IDENTIFICATION

<INITIAL>bvar_density<DYNARE_STATEMENT> BVAR_DENSITY
<INITIAL>bvar_forecast<DYNARE_STATEMENT> BVAR_FORECAST
<INITIAL>bvar_irf<DYNARE_STATEMENT> BVAR_IRF
<INITIAL>dynare_sensitivity<DYNARE_STATEMENT> DYNARE_SENSITIVITY
<INITIAL>initval_file<DYNARE_STATEMENT> INITVAL_FILE
<INITIAL>histval_file<DYNARE_STATEMENT> HISTVAL_FILE
<INITIAL>forecast<DYNARE_STATEMENT> FORECAST
<INITIAL>shock_decomposition<DYNARE_STATEMENT> SHOCK_DECOMPOSITION
<INITIAL>realtime_shock_decomposition<DYNARE_STATEMENT> REALTIME_SHOCK_DECOMPOSITION
<INITIAL>plot_shock_decomposition<DYNARE_STATEMENT> PLOT_SHOCK_DECOMPOSITION
<INITIAL>initial_condition_decomposition<DYNARE_STATEMENT> INITIAL_CONDITION_DECOMPOSITION
<INITIAL>squeeze_shock_decomposition<DYNARE_STATEMENT> SQUEEZE_SHOCK_DECOMPOSITION
<INITIAL>sbvar<DYNARE_STATEMENT> SBVAR
<INITIAL>ms_estimation<DYNARE_STATEMENT> MS_ESTIMATION
<INITIAL>ms_simulation<DYNARE_STATEMENT> MS_SIMULATION
<INITIAL>ms_compute_mdd<DYNARE_STATEMENT> MS_COMPUTE_MDD
<INITIAL>ms_compute_probabilities<DYNARE_STATEMENT> MS_COMPUTE_PROBABILITIES
<INITIAL>ms_forecast<DYNARE_STATEMENT> MS_FORECAST
<INITIAL>ms_irf<DYNARE_STATEMENT> MS_IRF
<INITIAL>ms_variance_decomposition<DYNARE_STATEMENT> MS_VARIANCE_DECOMPOSITION
<INITIAL>conditional_forecast<DYNARE_STATEMENT> CONDITIONAL_FORECAST
<INITIAL>plot_conditional_forecast<DYNARE_STATEMENT> PLOT_CONDITIONAL_FORECAST
<INITIAL>method_of_moments<DYNARE_STATEMENT> METHOD_OF_MOMENTS

<INITIAL>markov_switching<DYNARE_STATEMENT> MARKOV_SWITCHING
<INITIAL>svar<DYNARE_STATEMENT> SVAR
<INITIAL>svar_global_identification_check<DYNARE_STATEMENT> SVAR_GLOBAL_IDENTIFICATION_CHECK
<INITIAL>external_function<DYNARE_STATEMENT> EXTERNAL_FUNCTION
 /* End of a Dynare statement */
<INITIAL>calib_smoother<DYNARE_STATEMENT> CALIB_SMOOTHER
<INITIAL>model_diagnostics<DYNARE_STATEMENT> MODEL_DIAGNOSTICS
<INITIAL>extended_path<DYNARE_STATEMENT> EXTENDED_PATH
<INITIAL>smoother2histval<DYNARE_STATEMENT> SMOOTHER2HISTVAL
<INITIAL>perfect_foresight_setup<DYNARE_STATEMENT> PERFECT_FORESIGHT_SETUP
<INITIAL>perfect_foresight_solver<DYNARE_STATEMENT> PERFECT_FORESIGHT_SOLVER
<INITIAL>perfect_foresight_with_expectation_errors_setup<DYNARE_STATEMENT> PERFECT_FORESIGHT_WITH_EXPECTATION_ERRORS_SETUP
<INITIAL>perfect_foresight_with_expectation_errors_solver<DYNARE_STATEMENT> PERFECT_FORESIGHT_WITH_EXPECTATION_ERRORS_SOLVER
<INITIAL>compilation_setup<DYNARE_STATEMENT> COMPILATION_SETUP
<INITIAL>model_remove<DYNARE_STATEMENT> MODEL_REMOVE
<INITIAL>model_options<DYNARE_STATEMENT> MODEL_OPTIONS
<INITIAL>var_remove<DYNARE_STATEMENT> VAR_REMOVE
<INITIAL>resid<DYNARE_STATEMENT> RESID

<DYNARE_STATEMENT>;<INITIAL> ';'


 /* Begin of a Dynare block */
<INITIAL>model<DYNARE_BLOCK> MODEL
<INITIAL>steady_state_model<DYNARE_BLOCK> STEADY_STATE_MODEL
<INITIAL>initval<DYNARE_BLOCK> INITVAL
<INITIAL>endval<DYNARE_BLOCK> ENDVAL
<INITIAL>histval<DYNARE_BLOCK> HISTVAL
<INITIAL>filter_initial_state<DYNARE_BLOCK> FILTER_INITIAL_STATE
<INITIAL>shocks<DYNARE_BLOCK> SHOCKS
<INITIAL>heteroskedastic_shocks<DYNARE_BLOCK> HETEROSKEDASTIC_SHOCKS
<INITIAL>shock_groups<DYNARE_BLOCK> SHOCK_GROUPS
<INITIAL>init2shocks<DYNARE_BLOCK> INIT2SHOCKS
<INITIAL>mshocks<DYNARE_BLOCK> MSHOCKS
<INITIAL>estimated_params<DYNARE_BLOCK> ESTIMATED_PARAMS
<INITIAL>epilogue<DYNARE_BLOCK> EPILOGUE
 /* priors is an alias for estimated_params */
<INITIAL>priors<DYNARE_BLOCK> ESTIMATED_PARAMS
<INITIAL>estimated_params_init<DYNARE_BLOCK> ESTIMATED_PARAMS_INIT
<INITIAL>estimated_params_bounds<DYNARE_BLOCK> ESTIMATED_PARAMS_BOUNDS
<INITIAL>estimated_params_remove<DYNARE_BLOCK> ESTIMATED_PARAMS_REMOVE
<INITIAL>osr_params_bounds<DYNARE_BLOCK> OSR_PARAMS_BOUNDS
<INITIAL>observation_trends<DYNARE_BLOCK> OBSERVATION_TRENDS
<INITIAL>deterministic_trends<DYNARE_BLOCK> DETERMINISTIC_TRENDS
<INITIAL>optim_weights<DYNARE_BLOCK> OPTIM_WEIGHTS
<INITIAL>homotopy_setup<DYNARE_BLOCK> HOMOTOPY_SETUP
<INITIAL>conditional_forecast_paths<DYNARE_BLOCK> CONDITIONAL_FORECAST_PATHS
<INITIAL>svar_identification<DYNARE_BLOCK> SVAR_IDENTIFICATION
<INITIAL>moment_calibration<DYNARE_BLOCK> MOMENT_CALIBRATION
<INITIAL>irf_calibration<DYNARE_BLOCK> IRF_CALIBRATION
<INITIAL>ramsey_constraints<DYNARE_BLOCK> RAMSEY_CONSTRAINTS
<INITIAL>generate_irfs<DYNARE_BLOCK> GENERATE_IRFS
<INITIAL>matched_moments<DYNARE_BLOCK> MATCHED_MOMENTS
<INITIAL>occbin_constraints<DYNARE_BLOCK> OCCBIN_CONSTRAINTS
<INITIAL>model_replace<DYNARE_BLOCK> MODEL_REPLACE
<INITIAL>pac_target_info<DYNARE_BLOCK> PAC_TARGET_INFO

 /* For the semicolon after an "end" keyword */
<INITIAL>;	';'

 /* End of a Dynare block */
<DYNARE_BLOCK>end<INITIAL> 	END

<DYNARE_STATEMENT>subsamples SUBSAMPLES
<DYNARE_STATEMENT>options OPTIONS
<DYNARE_STATEMENT>prior PRIOR

<INITIAL>std<DYNARE_STATEMENT> STD
<INITIAL>corr<DYNARE_STATEMENT> CORR
<DYNARE_STATEMENT>function FUNCTION
<DYNARE_STATEMENT>sampling_draws SAMPLING_DRAWS
<INITIAL>prior_function<DYNARE_STATEMENT> PRIOR_FUNCTION
<INITIAL>posterior_function<DYNARE_STATEMENT> POSTERIOR_FUNCTION

 /* Inside  of a Dynare statement */
<DYNARE_STATEMENT>{DATE}<.>
<DYNARE_STATEMENT>\${DATE}<.>
<DYNARE_STATEMENT>dates<>DATES_STATEMENT>
<DYNARE_STATEMENT>file                  FILE
<DYNARE_STATEMENT>datafile 		DATAFILE
<DYNARE_STATEMENT>dirname       DIRNAME
<DYNARE_STATEMENT>nobs 			NOBS
<DYNARE_STATEMENT>last_obs 		LAST_OBS
<DYNARE_STATEMENT>first_obs 		FIRST_OBS
<DYNARE_STATEMENT>mean                  MEAN
<DYNARE_STATEMENT>stdev                 STDEV
<DYNARE_STATEMENT>truncate              TRUNCATE
<DYNARE_STATEMENT>domain                DOMAINN // Use altered token name to avoid identifier collision on Windows and macOS
<DYNARE_STATEMENT>variance              VARIANCE
<DYNARE_STATEMENT>mode                  MODE
<DYNARE_STATEMENT>interval              INTERVAL
<DYNARE_STATEMENT>shape                 SHAPE
<DYNARE_STATEMENT>shift                 SHIFT
<DYNARE_STATEMENT>bounds                BOUNDS
<DYNARE_STATEMENT>init                  INIT
<DYNARE_STATEMENT>jscale                JSCALE
<DYNARE_STATEMENT>prefilter 		PREFILTER
<DYNARE_STATEMENT>presample 		PRESAMPLE
<DYNARE_STATEMENT>lik_algo  		LIK_ALGO
<DYNARE_STATEMENT>lik_init  		LIK_INIT
<DYNARE_STATEMENT>taper_steps       TAPER_STEPS
<DYNARE_STATEMENT>geweke_interval   GEWEKE_INTERVAL
<DYNARE_STATEMENT>raftery_lewis_qrs RAFTERY_LEWIS_QRS
<DYNARE_STATEMENT>raftery_lewis_diagnostics RAFTERY_LEWIS_DIAGNOSTICS
<DYNARE_STATEMENT>brooks_gelman_plotrows BROOKS_GELMAN_PLOTROWS
<DYNARE_STATEMENT>graph   		GRAPH
<DYNARE_STATEMENT>nograph   		NOGRAPH
<DYNARE_STATEMENT>posterior_graph   		POSTERIOR_GRAPH
<DYNARE_STATEMENT>posterior_nograph   		POSTERIOR_NOGRAPH
<DYNARE_STATEMENT>nodisplay     NODISPLAY
<DYNARE_STATEMENT>graph_format  GRAPH_FORMAT
<DYNARE_STATEMENT>eps  EPS
<DYNARE_STATEMENT>pdf  PDF
<DYNARE_STATEMENT>fig  FIG
<DYNARE_STATEMENT>none  NONE
<DYNARE_STATEMENT>print   		PRINT
<DYNARE_STATEMENT>noprint   		NOPRINT
<DYNARE_STATEMENT>conf_sig  		CONF_SIG
<DYNARE_STATEMENT>mh_conf_sig  		MH_CONF_SIG
<DYNARE_STATEMENT>mh_replic 		MH_REPLIC
<DYNARE_STATEMENT>mh_drop   		MH_DROP
<DYNARE_STATEMENT>mh_jscale   		MH_JSCALE
<DYNARE_STATEMENT>mh_init_scale 	MH_INIT_SCALE
<DYNARE_STATEMENT>mh_init_scale_factor 	MH_INIT_SCALE_FACTOR
<DYNARE_STATEMENT>mh_tune_jscale   	MH_TUNE_JSCALE
<DYNARE_STATEMENT>mh_tune_guess   	MH_TUNE_GUESS
<DYNARE_STATEMENT>mode_file 		MODE_FILE
<DYNARE_STATEMENT>mode_compute 	MODE_COMPUTE
<DYNARE_STATEMENT>mode_check 		MODE_CHECK
<DYNARE_STATEMENT>mode_check_neighbourhood_size 		MODE_CHECK_NEIGHBOURHOOD_SIZE
<DYNARE_STATEMENT>mode_check_symmetric_plots 		MODE_CHECK_SYMMETRIC_PLOTS
<DYNARE_STATEMENT>mode_check_number_of_points 		MODE_CHECK_NUMBER_OF_POINTS
<DYNARE_STATEMENT>prior_trunc 	PRIOR_TRUNC
<DYNARE_STATEMENT>mh_posterior_mode_estimation 		MH_POSTERIOR_MODE_ESTIMATION
<DYNARE_STATEMENT>mh_nblocks 		MH_NBLOCKS
<DYNARE_STATEMENT>load_mh_file 	LOAD_MH_FILE
<DYNARE_STATEMENT>load_results_after_load_mh 	LOAD_RESULTS_AFTER_LOAD_MH
<DYNARE_STATEMENT>loglinear 		LOGLINEAR
<DYNARE_STATEMENT>linear_approximation 		LINEAR_APPROXIMATION
<DYNARE_STATEMENT>logdata 	LOGDATA
<DYNARE_STATEMENT>nodiagnostic 	NODIAGNOSTIC
<DYNARE_STATEMENT>kalman_algo 	KALMAN_ALGO
<DYNARE_STATEMENT>fast_kalman_filter FAST_KALMAN_FILTER
<DYNARE_STATEMENT>kalman_tol 	KALMAN_TOL
<DYNARE_STATEMENT>schur_vec_tol 	SCHUR_VEC_TOL
<DYNARE_STATEMENT>diffuse_kalman_tol 	DIFFUSE_KALMAN_TOL
<DYNARE_STATEMENT>forecast 	FORECAST
<DYNARE_STATEMENT>smoother 	SMOOTHER
<DYNARE_STATEMENT>bayesian_irf 	BAYESIAN_IRF
<DYNARE_STATEMENT>dsge_var 	DSGE_VAR
<DYNARE_STATEMENT>dsge_varlag 	DSGE_VARLAG
<DYNARE_STATEMENT>moments_varendo MOMENTS_VARENDO
<DYNARE_STATEMENT>contemporaneous_correlation CONTEMPORANEOUS_CORRELATION
<DYNARE_STATEMENT>posterior_max_subsample_draws	POSTERIOR_MAX_SUBSAMPLE_DRAWS
<DYNARE_STATEMENT>filtered_vars	FILTERED_VARS
<DYNARE_STATEMENT>filter_step_ahead	FILTER_STEP_AHEAD
<DYNARE_STATEMENT,DYNARE_BLOCK>relative_irf RELATIVE_IRF
<DYNARE_STATEMENT>tex		TEX
<DYNARE_STATEMENT>nomoments	NOMOMENTS
<DYNARE_STATEMENT>std		STD
<DYNARE_STATEMENT>corr		CORR
<DYNARE_STATEMENT>nocorr	NOCORR
<DYNARE_STATEMENT>optim		OPTIM
<DYNARE_STATEMENT>periods	PERIODS
<DYNARE_STATEMENT>endval_steady	ENDVAL_STEADY
<DYNARE_STATEMENT,DYNARE_BLOCK>model_name	MODEL_NAME
<DYNARE_STATEMENT>auxiliary_model_name    AUXILIARY_MODEL_NAME
<DYNARE_STATEMENT>endogenous_terminal_period 	ENDOGENOUS_TERMINAL_PERIOD
<DYNARE_STATEMENT>sub_draws	SUB_DRAWS
<DYNARE_STATEMENT>minimal_solving_periods MINIMAL_SOLVING_PERIODS
<DYNARE_STATEMENT>markowitz	MARKOWITZ
<DYNARE_STATEMENT>marginal_density MARGINAL_DENSITY
<DYNARE_STATEMENT>laplace       LAPLACE
<DYNARE_STATEMENT>modifiedharmonicmean MODIFIEDHARMONICMEAN
<DYNARE_STATEMENT>constant	CONSTANT
<DYNARE_STATEMENT>noconstant	NOCONSTANT
<DYNARE_STATEMENT>filename      FILENAME
<DYNARE_STATEMENT>conditional_likelihood      CONDITIONAL_LIKELIHOOD
<DYNARE_STATEMENT>diffuse_filter DIFFUSE_FILTER
<DYNARE_STATEMENT>plot_priors   PLOT_PRIORS
<DYNARE_STATEMENT>aim_solver AIM_SOLVER
<DYNARE_STATEMENT>partial_information PARTIAL_INFORMATION
<DYNARE_STATEMENT>conditional_variance_decomposition CONDITIONAL_VARIANCE_DECOMPOSITION
<DYNARE_STATEMENT>name EXT_FUNC_NAME
<DYNARE_STATEMENT>nargs EXT_FUNC_NARGS
<DYNARE_STATEMENT>first_deriv_provided FIRST_DERIV_PROVIDED
<DYNARE_STATEMENT>second_deriv_provided SECOND_DERIV_PROVIDED
<DYNARE_STATEMENT>freq FREQ
<DYNARE_STATEMENT>monthly MONTHLY
<DYNARE_STATEMENT>quarterly QUARTERLY
<DYNARE_STATEMENT>initial_year INITIAL_YEAR
<DYNARE_STATEMENT>initial_subperiod INITIAL_SUBPERIOD
<DYNARE_STATEMENT>final_year FINAL_YEAR
<DYNARE_STATEMENT>final_subperiod FINAL_SUBPERIOD
<DYNARE_STATEMENT>vlist VLIST
<DYNARE_STATEMENT>vlistlog VLISTLOG
<DYNARE_STATEMENT>vlistper VLISTPER
<DYNARE_STATEMENT>keep_kalman_algo_if_singularity_is_detected KEEP_KALMAN_ALGO_IF_SINGULARITY_IS_DETECTED
<DYNARE_STATEMENT>restriction_fname RESTRICTION_FNAME
<DYNARE_STATEMENT>nlags NLAGS
<DYNARE_STATEMENT>restrictions RESTRICTIONS
<DYNARE_BLOCK>adl ADL
<DYNARE_STATEMENT,DYNARE_BLOCK>diff DIFF
<DYNARE_STATEMENT>cross_restrictions CROSS_RESTRICTIONS
<DYNARE_STATEMENT>contemp_reduced_form CONTEMP_REDUCED_FORM
<DYNARE_STATEMENT>real_pseudo_forecast REAL_PSEUDO_FORECAST
<DYNARE_STATEMENT>no_bayesian_prior NO_BAYESIAN_PRIOR
<DYNARE_STATEMENT>dummy_obs DUMMY_OBS
<DYNARE_STATEMENT>spectral_density SPECTRAL_DENSITY
<DYNARE_STATEMENT>nstates NSTATES
<DYNARE_STATEMENT>indxscalesstates INDXSCALESSTATES
<DYNARE_STATEMENT>fixed_point FIXED_POINT
<DYNARE_STATEMENT>doubling DOUBLING
<DYNARE_STATEMENT>plot_init_date PLOT_INIT_DATE
<DYNARE_STATEMENT>plot_end_date PLOT_END_DATE
<DYNARE_STATEMENT>square_root_solver SQUARE_ROOT_SOLVER
<DYNARE_STATEMENT>cycle_reduction CYCLE_REDUCTION
<DYNARE_STATEMENT>logarithmic_reduction LOGARITHMIC_REDUCTION
<DYNARE_STATEMENT>use_univariate_filters_if_singularity_is_detected USE_UNIVARIATE_FILTERS_IF_SINGULARITY_IS_DETECTED
<DYNARE_STATEMENT>hybrid HYBRID
<DYNARE_STATEMENT>default DEFAULT
<DYNARE_STATEMENT>init2shocks INIT2SHOCKS

<DYNARE_STATEMENT>number_of_particles NUMBER_OF_PARTICLES
<DYNARE_STATEMENT>resampling RESAMPLING
<DYNARE_STATEMENT>systematic SYSTEMATIC
<DYNARE_STATEMENT>generic GENERIC
<DYNARE_STATEMENT>resampling_threshold RESAMPLING_THRESHOLD
<DYNARE_STATEMENT>resampling_method RESAMPLING_METHOD
<DYNARE_STATEMENT>kitagawa KITAGAWA
<DYNARE_STATEMENT>smooth SMOOTH
<DYNARE_STATEMENT>stratified STRATIFIED
<DYNARE_STATEMENT>cpf_weights CPF_WEIGHTS
<DYNARE_STATEMENT>amisanotristani AMISANOTRISTANI
<DYNARE_STATEMENT>murrayjonesparslow MURRAYJONESPARSLOW
<DYNARE_STATEMENT>filter_algorithm FILTER_ALGORITHM
<DYNARE_STATEMENT>nonlinear_filter_initialization NONLINEAR_FILTER_INITIALIZATION
<DYNARE_STATEMENT>proposal_approximation PROPOSAL_APPROXIMATION
<DYNARE_STATEMENT>cubature CUBATURE
<DYNARE_STATEMENT>unscented UNSCENTED
<DYNARE_STATEMENT>montecarlo MONTECARLO
<DYNARE_STATEMENT>distribution_approximation DISTRIBUTION_APPROXIMATION
<DYNARE_STATEMENT>proposal_distribution PROPOSAL_DISTRIBUTION
<DYNARE_STATEMENT>no_posterior_kernel_density NO_POSTERIOR_KERNEL_DENSITY
<DYNARE_STATEMENT>rescale_prediction_error_covariance RESCALE_PREDICTION_ERROR_COVARIANCE
<DYNARE_STATEMENT>use_penalized_objective_for_hessian USE_PENALIZED_OBJECTIVE_FOR_HESSIAN
<DYNARE_STATEMENT>expression    EXPRESSION
<DYNARE_STATEMENT>first_simulation_period FIRST_SIMULATION_PERIOD
<DYNARE_STATEMENT>last_simulation_period LAST_SIMULATION_PERIOD
<DYNARE_STATEMENT>no_init_estimation_check_first_obs NO_INIT_ESTIMATION_CHECK_FIRST_OBS
<DYNARE_STATEMENT>fsolve_options FSOLVE_OPTIONS

<DYNARE_STATEMENT>alpha ALPHA
<DYNARE_STATEMENT>beta BETA
<DYNARE_STATEMENT>gamma GAMMA
<DYNARE_STATEMENT>inv_gamma INV_GAMMA
<DYNARE_STATEMENT>inv_gamma1 INV_GAMMA1
<DYNARE_STATEMENT>inv_gamma2 INV_GAMMA2
<DYNARE_STATEMENT>dirichlet DIRICHLET
<DYNARE_STATEMENT>weibull WEIBULL
<DYNARE_STATEMENT>normal NORMAL
<DYNARE_STATEMENT>uniform UNIFORM
<DYNARE_STATEMENT>gsig2_lmdm GSIG2_LMDM
<DYNARE_STATEMENT>specification SPECIFICATION
<DYNARE_STATEMENT>sims_zha SIMS_ZHA
<DYNARE_STATEMENT>q_diag Q_DIAG
<DYNARE_STATEMENT>flat_prior FLAT_PRIOR
<DYNARE_STATEMENT>ncsk NCSK
<DYNARE_STATEMENT>nstd NSTD
<DYNARE_STATEMENT>ninv NINV
<DYNARE_STATEMENT>indxparr INDXPARR
<DYNARE_STATEMENT>indxovr INDXOVR
<DYNARE_STATEMENT>aband ABAND
<DYNARE_STATEMENT>write_equation_tags WRITE_EQUATION_TAGS
<DYNARE_STATEMENT>eqtags EQTAGS
<DYNARE_STATEMENT>targets TARGETS
<DYNARE_STATEMENT>indxap INDXAP
<DYNARE_STATEMENT>apband APBAND
<DYNARE_STATEMENT>indximf INDXIMF
<DYNARE_STATEMENT>indxfore INDXFORE
<DYNARE_STATEMENT>foreband FOREBAND
<DYNARE_STATEMENT>indxgforehat INDXGFOREHAT
<DYNARE_STATEMENT>indxgimfhat INDXGIMFHAT
<DYNARE_STATEMENT>indxestima INDXESTIMA
<DYNARE_STATEMENT>indxgdls INDXGDLS
<DYNARE_STATEMENT>eq_ms EQ_MS
<DYNARE_STATEMENT>cms CMS
<DYNARE_STATEMENT>ncms NCMS
<DYNARE_STATEMENT>eq_cms EQ_CMS
<DYNARE_STATEMENT>tlindx TLINDX
<DYNARE_STATEMENT>tlnumber TLNUMBER
<DYNARE_STATEMENT>cnum CNUM
<DYNARE_STATEMENT>nodecomposition NODECOMPOSITION
<DYNARE_BLOCK>use_calibration USE_CALIBRATION
<DYNARE_STATEMENT>output_file_tag OUTPUT_FILE_TAG
<DYNARE_STATEMENT>file_tag FILE_TAG
<DYNARE_STATEMENT>no_create_init NO_CREATE_INIT
<DYNARE_STATEMENT>simulation_file_tag SIMULATION_FILE_TAG
<DYNARE_STATEMENT>horizon HORIZON
<DYNARE_STATEMENT>parameter_uncertainty PARAMETER_UNCERTAINTY
<DYNARE_STATEMENT>no_error_bands NO_ERROR_BANDS
<DYNARE_STATEMENT>error_band_percentiles ERROR_BAND_PERCENTILES
<DYNARE_STATEMENT>shock_draws SHOCK_DRAWS
<DYNARE_STATEMENT>shocks_per_parameter SHOCKS_PER_PARAMETER
<DYNARE_STATEMENT>thinning_factor THINNING_FACTOR
<DYNARE_STATEMENT>free_parameters FREE_PARAMETERS
<DYNARE_STATEMENT>median MEDIAN
<DYNARE_STATEMENT>regime REGIME
<DYNARE_STATEMENT>regimes REGIMES
<DYNARE_STATEMENT>data_obs_nbr DATA_OBS_NBR
<DYNARE_STATEMENT>filtered_probabilities FILTERED_PROBABILITIES
<DYNARE_STATEMENT>real_time_smoothed REAL_TIME_SMOOTHED
<DYNARE_STATEMENT>proposal_type PROPOSAL_TYPE
<DYNARE_STATEMENT>proposal_lower_bound PROPOSAL_LOWER_BOUND
<DYNARE_STATEMENT>proposal_upper_bound PROPOSAL_UPPER_BOUND
<DYNARE_STATEMENT>proposal_draws PROPOSAL_DRAWS
<DYNARE_STATEMENT>use_mean_center USE_MEAN_CENTER
<DYNARE_STATEMENT>adaptive_mh_draws ADAPTIVE_MH_DRAWS
<DYNARE_STATEMENT>coefficients_prior_hyperparameters COEFFICIENTS_PRIOR_HYPERPARAMETERS
<DYNARE_STATEMENT>convergence_starting_value CONVERGENCE_STARTING_VALUE
<DYNARE_STATEMENT>convergence_ending_value CONVERGENCE_ENDING_VALUE
<DYNARE_STATEMENT>convergence_increment_value CONVERGENCE_INCREMENT_VALUE
<DYNARE_STATEMENT>max_iterations_starting_value MAX_ITERATIONS_STARTING_VALUE
<DYNARE_STATEMENT>max_iterations_increment_value MAX_ITERATIONS_INCREMENT_VALUE
<DYNARE_STATEMENT>max_block_iterations MAX_BLOCK_ITERATIONS
<DYNARE_STATEMENT>max_repeated_optimization_runs MAX_REPEATED_OPTIMIZATION_RUNS
<DYNARE_STATEMENT>maxit MAXIT
<DYNARE_STATEMENT>simul_maxit SIMUL_MAXIT
<DYNARE_STATEMENT>likelihood_maxit LIKELIHOOD_MAXIT
<DYNARE_STATEMENT>smoother_maxit SMOOTHER_MAXIT
<DYNARE_STATEMENT>simul_periods SIMUL_PERIODS
<DYNARE_STATEMENT>likelihood_periods LIKELIHOOD_PERIODS
<DYNARE_STATEMENT>smoother_periods SMOOTHER_PERIODS
<DYNARE_STATEMENT>simul_curb_retrench SIMUL_CURB_RETRENCH
<DYNARE_STATEMENT>likelihood_curb_retrench LIKELIHOOD_CURB_RETRENCH
<DYNARE_STATEMENT>smoother_curb_retrench SMOOTHER_CURB_RETRENCH
<DYNARE_STATEMENT>simul_check_ahead_periods SIMUL_CHECK_AHEAD_PERIODS
<DYNARE_STATEMENT>simul_max_check_ahead_periods SIMUL_MAX_CHECK_AHEAD_PERIODS
<DYNARE_STATEMENT>simul_reset_check_ahead_periods SIMUL_RESET_CHECK_AHEAD_PERIODS
<DYNARE_STATEMENT>likelihood_check_ahead_periods LIKELIHOOD_CHECK_AHEAD_PERIODS
<DYNARE_STATEMENT>likelihood_max_check_ahead_periods LIKELIHOOD_MAX_CHECK_AHEAD_PERIODS
<DYNARE_STATEMENT>smoother_check_ahead_periods SMOOTHER_CHECK_AHEAD_PERIODS
<DYNARE_STATEMENT>smoother_max_check_ahead_periods SMOOTHER_MAX_CHECK_AHEAD_PERIODS
<DYNARE_STATEMENT>simul_debug SIMUL_DEBUG
<DYNARE_STATEMENT>smoother_debug SMOOTHER_DEBUG
<DYNARE_STATEMENT>simul_periodic_solution SIMUL_PERIODIC_SOLUTION
<DYNARE_STATEMENT>likelihood_periodic_solution LIKELIHOOD_PERIODIC_SOLUTION
<DYNARE_STATEMENT>smoother_periodic_solution SMOOTHER_PERIODIC_SOLUTION
<DYNARE_STATEMENT>likelihood_inversion_filter LIKELIHOOD_INVERSION_FILTER
<DYNARE_STATEMENT>likelihood_piecewise_kalman_filter LIKELIHOOD_PIECEWISE_KALMAN_FILTER
<DYNARE_STATEMENT>likelihood_max_kalman_iterations LIKELIHOOD_MAX_KALMAN_ITERATIONS
<DYNARE_STATEMENT>smoother_inversion_filter SMOOTHER_INVERSION_FILTER
<DYNARE_STATEMENT>smoother_piecewise_kalman_filter SMOOTHER_PIECEWISE_KALMAN_FILTER
<DYNARE_STATEMENT>filter_use_relaxation FILTER_USE_RELEXATION
<DYNARE_STATEMENT>function_convergence_criterion FUNCTION_CONVERGENCE_CRITERION
<DYNARE_STATEMENT>parameter_convergence_criterion PARAMETER_CONVERGENCE_CRITERION
<DYNARE_STATEMENT>number_of_large_perturbations NUMBER_OF_LARGE_PERTURBATIONS
<DYNARE_STATEMENT>number_of_small_perturbations NUMBER_OF_SMALL_PERTURBATIONS
<DYNARE_STATEMENT>number_of_posterior_draws_after_perturbation NUMBER_OF_POSTERIOR_DRAWS_AFTER_PERTURBATION
<DYNARE_STATEMENT>max_number_of_stages MAX_NUMBER_OF_STAGES
<DYNARE_STATEMENT>random_function_convergence_criterion RANDOM_FUNCTION_CONVERGENCE_CRITERION
<DYNARE_STATEMENT>random_parameter_convergence_criterion RANDOM_PARAMETER_CONVERGENCE_CRITERION
<DYNARE_STATEMENT>tolf TOLF
<DYNARE_STATEMENT>tolx TOLX
<DYNARE_STATEMENT>opt_algo OPT_ALGO
<DYNARE_STATEMENT>add_flags ADD_FLAGS
<DYNARE_STATEMENT>substitute_flags SUBSTITUTE_FLAGS
<DYNARE_STATEMENT>add_libs ADD_LIBS
<DYNARE_STATEMENT>substitute_libs SUBSTITUTE_LIBS
<DYNARE_STATEMENT>compiler COMPILER
<DYNARE_STATEMENT>instruments INSTRUMENTS
<DYNARE_STATEMENT>hessian  HESSIAN
<DYNARE_STATEMENT>prior_variance  PRIOR_VARIANCE

<DYNARE_STATEMENT>identity_matrix  IDENTITY_MATRIX

<DYNARE_STATEMENT>mcmc_jumping_covariance MCMC_JUMPING_COVARIANCE

 /* These four (var, varexo, varexo_det, parameters) are for change_type */
<DYNARE_STATEMENT>var VAR
<DYNARE_STATEMENT>varexo VAREXO
<DYNARE_STATEMENT>varexo_det VAREXO_DET
<DYNARE_STATEMENT>parameters PARAMETERS
<DYNARE_STATEMENT>predetermined_variables PREDETERMINED_VARIABLES

<DYNARE_STATEMENT>bvar_prior_tau BVAR_PRIOR_TAU
<DYNARE_STATEMENT>bvar_prior_decay BVAR_PRIOR_DECAY
<DYNARE_STATEMENT>bvar_prior_lambda BVAR_PRIOR_LAMBDA
<DYNARE_STATEMENT>bvar_prior_mu BVAR_PRIOR_MU
<DYNARE_STATEMENT>bvar_prior_omega BVAR_PRIOR_OMEGA
<DYNARE_STATEMENT>bvar_prior_flat BVAR_PRIOR_FLAT
<DYNARE_STATEMENT>bvar_prior_train BVAR_PRIOR_TRAIN
<DYNARE_STATEMENT>bvar_replic BVAR_REPLIC

<DYNARE_STATEMENT>homotopy_mode HOMOTOPY_MODE
<DYNARE_STATEMENT>homotopy_steps HOMOTOPY_STEPS
<DYNARE_STATEMENT>homotopy_force_continue HOMOTOPY_FORCE_CONTINUE
<DYNARE_STATEMENT>homotopy_max_completion_share HOMOTOPY_MAX_COMPLETION_SHARE
<DYNARE_STATEMENT>homotopy_min_step_size HOMOTOPY_MIN_STEP_SIZE
<DYNARE_STATEMENT>homotopy_initial_step_size HOMOTOPY_INITIAL_STEP_SIZE
<DYNARE_STATEMENT>homotopy_step_size_increase_success_count HOMOTOPY_STEP_SIZE_INCREASE_SUCCESS_COUNT
<DYNARE_STATEMENT>homotopy_linearization_fallback HOMOTOPY_LINEARIZATION_FALLBACK
<DYNARE_STATEMENT>homotopy_marginal_linearization_fallback HOMOTOPY_MARGINAL_LINEARIZATION_FALLBACK
<DYNARE_STATEMENT>nocheck NOCHECK

<DYNARE_STATEMENT>steady_solve_algo STEADY_SOLVE_ALGO
<DYNARE_STATEMENT>steady_maxit STEADY_MAXIT
<DYNARE_STATEMENT>steady_tolf STEADY_TOLF
<DYNARE_STATEMENT>steady_tolx STEADY_TOLX
<DYNARE_STATEMENT>steady_markowitz STEADY_MARKOWITZ

<DYNARE_STATEMENT>controlled_varexo CONTROLLED_VAREXO
<DYNARE_STATEMENT>parameter_set PARAMETER_SET
<DYNARE_STATEMENT>init_state INIT_STATE
<DYNARE_STATEMENT>fast_realtime FAST_REALTIME
<DYNARE_STATEMENT>save_realtime SAVE_REALTIME
<DYNARE_STATEMENT>detail_plot DETAIL_PLOT
<DYNARE_STATEMENT>flip FLIP
<DYNARE_STATEMENT>interactive INTERACTIVE
<DYNARE_STATEMENT>screen_shocks SCREEN_SHOCKS
<DYNARE_STATEMENT>steadystate STEADYSTATE
<DYNARE_STATEMENT>type TYPE
<DYNARE_STATEMENT>qoq QOQ
<DYNARE_STATEMENT>yoy YOY
<DYNARE_STATEMENT>aoa AOA
<DYNARE_STATEMENT>unconditional UNCONDITIONAL
<DYNARE_STATEMENT>conditional CONDITIONAL
<DYNARE_STATEMENT>fig_name FIG_NAME
<DYNARE_STATEMENT>write_xls WRITE_XLS
<DYNARE_STATEMENT>realtime REALTIME
<DYNARE_STATEMENT>vintage VINTAGE
<DYNARE_STATEMENT>prior_mode PRIOR_MODE
<DYNARE_STATEMENT>prior_mean PRIOR_MEAN
<DYNARE_STATEMENT>posterior_mode POSTERIOR_MODE
<DYNARE_STATEMENT>posterior_mean POSTERIOR_MEAN
<DYNARE_STATEMENT>posterior_median POSTERIOR_MEDIAN
<DYNARE_STATEMENT>mle_mode MLE_MODE
<DYNARE_STATEMENT>k_order_solver K_ORDER_SOLVER
<DYNARE_STATEMENT>filter_covariance FILTER_COVARIANCE
<DYNARE_STATEMENT>updated_covariance UPDATED_COVARIANCE
<DYNARE_STATEMENT>filter_decomposition FILTER_DECOMPOSITION
<DYNARE_STATEMENT>smoothed_state_uncertainty SMOOTHED_STATE_UNCERTAINTY
<DYNARE_STATEMENT>smoother_redux SMOOTHER_REDUX
<DYNARE_STATEMENT>selected_variables_only SELECTED_VARIABLES_ONLY
<DYNARE_STATEMENT>pruning PRUNING
<DYNARE_STATEMENT>save_draws SAVE_DRAWS
<DYNARE_STATEMENT>deflator DEFLATOR
<DYNARE_STATEMENT>log_deflator LOG_DEFLATOR
<DYNARE_STATEMENT>epilogue EPILOGUE
<DYNARE_STATEMENT>growth_factor GROWTH_FACTOR
<DYNARE_STATEMENT>log_growth_factor LOG_GROWTH_FACTOR
<DYNARE_STATEMENT,DYNARE_BLOCK>growth GROWTH
<DYNARE_STATEMENT>cova_compute COVA_COMPUTE
<DYNARE_STATEMENT>discretionary_tol DISCRETIONARY_TOL
<DYNARE_STATEMENT>analytic_derivation ANALYTIC_DERIVATION
<DYNARE_STATEMENT>analytic_derivation_mode ANALYTIC_DERIVATION_MODE
<DYNARE_STATEMENT>solver_periods SOLVER_PERIODS
<DYNARE_STATEMENT>endogenous_prior ENDOGENOUS_PRIOR
<DYNARE_STATEMENT>consider_all_endogenous CONSIDER_ALL_ENDOGENOUS
<DYNARE_STATEMENT>consider_all_endogenous_and_auxiliary CONSIDER_ALL_ENDOGENOUS_AND_AUXILIARY
<DYNARE_STATEMENT>consider_only_observed CONSIDER_ONLY_OBSERVED
<DYNARE_STATEMENT>infile INFILE
<DYNARE_STATEMENT>invars INVARS
<DYNARE_STATEMENT>period PERIOD
<DYNARE_STATEMENT>outfile OUTFILE
<DYNARE_STATEMENT>outvars OUTVARS
<DYNARE_STATEMENT>huge_number HUGE_NUMBER
<DYNARE_STATEMENT>dr_display_tol DR_DISPLAY_TOL
<DYNARE_STATEMENT>posterior_sampling_method POSTERIOR_SAMPLING_METHOD
<DYNARE_STATEMENT>posterior_sampler_options POSTERIOR_SAMPLER_OPTIONS
<DYNARE_STATEMENT>silent_optimizer SILENT_OPTIMIZER
<DYNARE_STATEMENT>lmmcp LMMCP
<DYNARE_STATEMENT>additional_optimizer_steps	ADDITIONAL_OPTIMIZER_STEPS
<DYNARE_STATEMENT>bartlett_kernel_lag BARTLETT_KERNEL_LAG
//<DYNARE_STATEMENT>optimal OPTIMAL
//<DYNARE_STATEMENT>diagonal  DIAGONAL
<DYNARE_STATEMENT>gmm GMM
<DYNARE_STATEMENT>smm SMM
<DYNARE_STATEMENT>weighting_matrix WEIGHTING_MATRIX
<DYNARE_STATEMENT>weighting_matrix_scaling_factor WEIGHTING_MATRIX_SCALING_FACTOR
<DYNARE_STATEMENT>analytic_standard_errors ANALYTIC_STANDARD_ERRORS
<DYNARE_STATEMENT>analytic_jacobian ANALYTIC_JACOBIAN
<DYNARE_STATEMENT>mom_method MOM_METHOD
<DYNARE_STATEMENT>penalized_estimator PENALIZED_ESTIMATOR
<DYNARE_STATEMENT>verbose VERBOSE
<DYNARE_STATEMENT>simulation_multiple SIMULATION_MULTIPLE
<DYNARE_STATEMENT>burnin BURNIN
<DYNARE_STATEMENT>seed SEED
<DYNARE_STATEMENT>se_tolx SE_TOLX
<DYNARE_STATEMENT>bounded_shock_support BOUNDED_SHOCK_SUPPORT
<DYNARE_STATEMENT>analytical_girf ANALYTICAL_GIRF
<DYNARE_STATEMENT>irf_in_percent IRF_IN_PERCENT
<DYNARE_STATEMENT>emas_girf EMAS_GIRF
<DYNARE_STATEMENT>emas_drop EMAS_DROP
<DYNARE_STATEMENT>emas_tolf EMAS_TOLF
<DYNARE_STATEMENT>emas_max_iter EMAS_MAX_ITER
<DYNARE_STATEMENT>variable VARIABLE
<DYNARE_STATEMENT>no_identification_strength NO_IDENTIFICATION_STRENGTH
<DYNARE_STATEMENT>no_identification_reducedform NO_IDENTIFICATION_REDUCEDFORM
<DYNARE_STATEMENT>no_identification_moments NO_IDENTIFICATION_MOMENTS
<DYNARE_STATEMENT>no_identification_minimal NO_IDENTIFICATION_MINIMAL
<DYNARE_STATEMENT>no_identification_spectrum NO_IDENTIFICATION_SPECTRUM
<DYNARE_STATEMENT>normalize_jacobians NORMALIZE_JACOBIANS
<DYNARE_STATEMENT>grid_nbr GRID_NBR
<DYNARE_STATEMENT>tol_rank TOL_RANK
<DYNARE_STATEMENT>tol_deriv TOL_DERIV
<DYNARE_STATEMENT>tol_sv TOL_SV
<DYNARE_STATEMENT>checks_via_subsets CHECKS_VIA_SUBSETS
<DYNARE_STATEMENT>max_dim_subsets_groups MAX_DIM_SUBSETS_GROUPS
<DYNARE_STATEMENT>zero_moments_tolerance ZERO_MOMENTS_TOLERANCE
<DYNARE_STATEMENT>max_nrows MAX_NROWS
<DYNARE_STATEMENT>with_epilogue WITH_EPILOGUE
<DYNARE_STATEMENT>heteroskedastic_filter HETEROSKEDASTIC_FILTER
<DYNARE_STATEMENT>non_zero NON_ZERO

<DYNARE_STATEMENT>\$[^$]*\$ TEX_NAME

 /* Inside a Dynare block */
<DYNARE_BLOCK>var VAR
<DYNARE_BLOCK>stderr STDERR
<DYNARE_BLOCK>values VALUES
<DYNARE_BLOCK>corr CORR
<DYNARE_BLOCK>periods PERIODS
<DYNARE_BLOCK>scales SCALES
<DYNARE_BLOCK>add ADD
<DYNARE_BLOCK>multiply MULTIPLY
<DYNARE_STATEMENT,DYNARE_BLOCK>cutoff CUTOFF
<DYNARE_STATEMENT,DYNARE_BLOCK>mfs MFS
<DYNARE_STATEMENT,DYNARE_BLOCK>balanced_growth_test_tol BALANCED_GROWTH_TEST_TOL
<DYNARE_BLOCK>gamma_pdf GAMMA_PDF
<DYNARE_BLOCK>beta_pdf BETA_PDF
<DYNARE_BLOCK>normal_pdf NORMAL_PDF
<DYNARE_BLOCK>inv_gamma_pdf INV_GAMMA_PDF
<DYNARE_BLOCK>inv_gamma1_pdf INV_GAMMA1_PDF
<DYNARE_BLOCK>inv_gamma2_pdf INV_GAMMA2_PDF
<DYNARE_BLOCK>uniform_pdf UNIFORM_PDF
<DYNARE_BLOCK>weibull_pdf WEIBULL_PDF
<DYNARE_BLOCK>dsge_prior_weight DSGE_PRIOR_WEIGHT
<DYNARE_BLOCK>surprise SURPRISE
<DYNARE_BLOCK>bind BIND
<DYNARE_BLOCK>relax RELAX
<DYNARE_BLOCK>error_bind ERROR_BIND
<DYNARE_BLOCK>error_relax ERROR_RELAX

<DYNARE_BLOCK>; ';'
<DYNARE_BLOCK># '#'

<DYNARE_BLOCK>restriction RESTRICTION
<DYNARE_BLOCK>component COMPONENT
<DYNARE_BLOCK>target TARGET
<DYNARE_BLOCK,DYNARE_STATEMENT>auxname AUXNAME
<DYNARE_BLOCK>auxname_target_nonstationary AUXNAME_TARGET_NONSTATIONARY
<DYNARE_BLOCK,DYNARE_STATEMENT>kind KIND
<DYNARE_BLOCK,DYNARE_STATEMENT>ll LL
<DYNARE_BLOCK,DYNARE_STATEMENT>dl DL
<DYNARE_BLOCK,DYNARE_STATEMENT>dd DD


 /* Inside Dynare statement */
<DYNARE_STATEMENT>solve_algo SOLVE_ALGO
<DYNARE_STATEMENT>dr_algo DR_ALGO
<DYNARE_STATEMENT>simul_algo SIMUL_ALGO
<DYNARE_STATEMENT>stack_solve_algo STACK_SOLVE_ALGO
<DYNARE_STATEMENT>robust_lin_solve ROBUST_LIN_SOLVE
<DYNARE_STATEMENT>drop DROP
<DYNARE_STATEMENT>order ORDER
<DYNARE_STATEMENT>sylvester SYLVESTER
<DYNARE_STATEMENT>lyapunov LYAPUNOV
<DYNARE_STATEMENT>dr DR
<DYNARE_STATEMENT>sylvester_fixed_point_tol SYLVESTER_FIXED_POINT_TOL
<DYNARE_STATEMENT>lyapunov_complex_threshold LYAPUNOV_COMPLEX_THRESHOLD
<DYNARE_STATEMENT>lyapunov_fixed_point_tol LYAPUNOV_FIXED_POINT_TOL
<DYNARE_STATEMENT>lyapunov_doubling_tol LYAPUNOV_DOUBLING_TOL
<DYNARE_STATEMENT>dr_cycle_reduction_tol DR_CYCLE_REDUCTION_TOL
<DYNARE_STATEMENT>dr_logarithmic_reduction_tol DR_LOGARITHMIC_REDUCTION_TOL
<DYNARE_STATEMENT>dr_logarithmic_reduction_maxiter DR_LOGARITHMIC_REDUCTION_MAXITER
<DYNARE_STATEMENT>replic REPLIC
<DYNARE_STATEMENT>ar AR
<DYNARE_STATEMENT>nofunctions NOFUNCTIONS
<DYNARE_STATEMENT>irf IRF
<DYNARE_STATEMENT>irf_shocks IRF_SHOCKS
<DYNARE_STATEMENT>hp_filter HP_FILTER
<DYNARE_STATEMENT>one_sided_hp_filter ONE_SIDED_HP_FILTER
<DYNARE_STATEMENT>bandpass_filter BANDPASS_FILTER
<DYNARE_STATEMENT>hp_ngrid HP_NGRID
<DYNARE_STATEMENT>filtered_theoretical_moments_grid FILTERED_THEORETICAL_MOMENTS_GRID
<DYNARE_STATEMENT>simul_seed SIMUL_SEED
<DYNARE_STATEMENT>qz_criterium QZ_CRITERIUM
<DYNARE_STATEMENT>qz_zero_threshold QZ_ZERO_THRESHOLD
<DYNARE_STATEMENT>simul SIMUL
<DYNARE_STATEMENT>simul_replic SIMUL_REPLIC
<DYNARE_STATEMENT>xls_sheet XLS_SHEET
<DYNARE_STATEMENT>xls_range XLS_RANGE
<DYNARE_STATEMENT>series SERIES
<DYNARE_STATEMENT>mh_recover MH_RECOVER
<DYNARE_STATEMENT>mh_initialize_from_previous_mcmc MH_INITIALIZE_FROM_PREVIOUS_MCMC
<DYNARE_STATEMENT>mh_initialize_from_previous_mcmc_directory MH_INITIALIZE_FROM_PREVIOUS_MCMC_DIRECTORY
<DYNARE_STATEMENT>mh_initialize_from_previous_mcmc_record MH_INITIALIZE_FROM_PREVIOUS_MCMC_RECORD
<DYNARE_STATEMENT>mh_initialize_from_previous_mcmc_prior MH_INITIALIZE_FROM_PREVIOUS_MCMC_PRIOR
<DYNARE_STATEMENT>planner_discount PLANNER_DISCOUNT
<DYNARE_STATEMENT>planner_discount_latex_name PLANNER_DISCOUNT_LATEX_NAME
<DYNARE_STATEMENT>calibration CALIBRATION
<DYNARE_STATEMENT>irf_plot_threshold IRF_PLOT_THRESHOLD
<DYNARE_STATEMENT>no_homotopy NO_HOMOTOPY
<DYNARE_STATEMENT>particle_filter_options PARTICLE_FILTER_OPTIONS
<DYNARE_STATEMENT>constant_simulation_length CONSTANT_SIMULATION_LENGTH
<DYNARE_STATEMENT>block_static BLOCK_STATIC
<DYNARE_STATEMENT>block_dynamic BLOCK_DYNAMIC
<DYNARE_STATEMENT>incidence INCIDENCE

<DYNARE_BLOCK>stderr_multiples STDERR_MULTIPLES
<DYNARE_BLOCK>diagonal_only DIAGONAL_ONLY
<DYNARE_BLOCK>equation EQUATION
<DYNARE_BLOCK>exclusion EXCLUSION
<DYNARE_BLOCK>lag LAG
<DYNARE_BLOCK>coeff COEFF
<DYNARE_BLOCK>overwrite OVERWRITE
<DYNARE_BLOCK>learnt_in LEARNT_IN
<DYNARE_STATEMENT,DYNARE_BLOCK>upper_cholesky UPPER_CHOLESKY
<DYNARE_STATEMENT,DYNARE_BLOCK>lower_cholesky LOWER_CHOLESKY
<DYNARE_STATEMENT>chain CHAIN
<DYNARE_STATEMENT>number_of_lags NUMBER_OF_LAGS
<DYNARE_STATEMENT>number_of_regimes NUMBER_OF_REGIMES
<DYNARE_STATEMENT>duration DURATION
<DYNARE_STATEMENT>coefficients COEFFICIENTS
<DYNARE_STATEMENT>variances VARIANCES
<DYNARE_STATEMENT>equations EQUATIONS
<DYNARE_STATEMENT>time_shift TIME_SHIFT
<DYNARE_STATEMENT>structural STRUCTURAL
<DYNARE_STATEMENT>true TRUE
<DYNARE_STATEMENT>false FALSE

<DYNARE_STATEMENT,DYNARE_BLOCK>\. '.'
/*<DYNARE_STATEMENT>\\ '\\'
<DYNARE_STATEMENT>\' '\''*/

<DYNARE_STATEMENT,DYNARE_BLOCK>use_dll USE_DLL
<DYNARE_STATEMENT,DYNARE_BLOCK>block BLOCK
<DYNARE_STATEMENT,DYNARE_BLOCK>bytecode BYTECODE
<DYNARE_BLOCK>all_values_required ALL_VALUES_REQUIRED
<DYNARE_STATEMENT,DYNARE_BLOCK>no_static NO_STATIC
<DYNARE_STATEMENT,DYNARE_BLOCK>differentiate_forward_vars DIFFERENTIATE_FORWARD_VARS
<DYNARE_STATEMENT,DYNARE_BLOCK>parallel_local_files PARALLEL_LOCAL_FILES

<DYNARE_STATEMENT,DYNARE_BLOCK>linear LINEAR

<DYNARE_STATEMENT,DYNARE_BLOCK>, COMMA
<DYNARE_STATEMENT,DYNARE_BLOCK>: ':'
//<DYNARE_STATEMENT,DYNARE_BLOCK>[\(\)] '[()]'
<DYNARE_STATEMENT,DYNARE_BLOCK>\[ '['
<DYNARE_STATEMENT,DYNARE_BLOCK>\] ']'
<DYNARE_STATEMENT,DYNARE_BLOCK>\+ PLUS
<DYNARE_STATEMENT,DYNARE_BLOCK>-  MINUS
<DYNARE_STATEMENT,DYNARE_BLOCK>\* TIMES
<DYNARE_STATEMENT,DYNARE_BLOCK>\/ DIVIDE
<DYNARE_STATEMENT,DYNARE_BLOCK>= EQUAL
<DYNARE_STATEMENT,DYNARE_BLOCK>< LESS
<DYNARE_STATEMENT,DYNARE_BLOCK>> GREATER
<DYNARE_STATEMENT,DYNARE_BLOCK>>= GREATER_EQUAL
<DYNARE_STATEMENT,DYNARE_BLOCK><= LESS_EQUAL
<DYNARE_STATEMENT,DYNARE_BLOCK>== EQUAL_EQUAL
<DYNARE_STATEMENT,DYNARE_BLOCK>!= EXCLAMATION_EQUAL
<DYNARE_BLOCK>\+= PLUS_EQUAL
<DYNARE_BLOCK>\*= TIMES_EQUAL
<DYNARE_STATEMENT,DYNARE_BLOCK>\^ POWER
<DYNARE_STATEMENT,DYNARE_BLOCK>exp EXP
<DYNARE_STATEMENT,DYNARE_BLOCK>log LOG
<DYNARE_STATEMENT,DYNARE_BLOCK>log10 LOG10
<DYNARE_STATEMENT,DYNARE_BLOCK>ln LN
<DYNARE_STATEMENT,DYNARE_BLOCK>sin SIN
<DYNARE_STATEMENT,DYNARE_BLOCK>cos COS
<DYNARE_STATEMENT,DYNARE_BLOCK>tan TAN
<DYNARE_STATEMENT,DYNARE_BLOCK>asin ASIN
<DYNARE_STATEMENT,DYNARE_BLOCK>acos ACOS
<DYNARE_STATEMENT,DYNARE_BLOCK>atan ATAN
<DYNARE_STATEMENT,DYNARE_BLOCK>sinh SINH
<DYNARE_STATEMENT,DYNARE_BLOCK>cosh COSH
<DYNARE_STATEMENT,DYNARE_BLOCK>tanh TANH
<DYNARE_STATEMENT,DYNARE_BLOCK>asinh ASINH
<DYNARE_STATEMENT,DYNARE_BLOCK>acosh ACOSH
<DYNARE_STATEMENT,DYNARE_BLOCK>atanh ATANH
<DYNARE_STATEMENT,DYNARE_BLOCK>sqrt SQRT
<DYNARE_STATEMENT,DYNARE_BLOCK>cbrt CBRT
<DYNARE_STATEMENT,DYNARE_BLOCK>max MAX
<DYNARE_STATEMENT,DYNARE_BLOCK>min MIN
<DYNARE_STATEMENT,DYNARE_BLOCK>abs ABS
<DYNARE_STATEMENT,DYNARE_BLOCK>sign SIGN
<DYNARE_STATEMENT,DYNARE_BLOCK>normcdf NORMCDF
<DYNARE_STATEMENT,DYNARE_BLOCK>normpdf NORMPDF
<DYNARE_STATEMENT,DYNARE_BLOCK>erf ERF
<DYNARE_STATEMENT,DYNARE_BLOCK>erfc ERFC
<DYNARE_STATEMENT,DYNARE_BLOCK>steady_state STEADY_STATE
<DYNARE_STATEMENT,DYNARE_BLOCK>expectation EXPECTATION
<DYNARE_BLOCK>var_expectation VAR_EXPECTATION
<DYNARE_BLOCK>pac_expectation PAC_EXPECTATION
<DYNARE_BLOCK>pac_target_nonstationary PAC_TARGET_NONSTATIONARY
<DYNARE_STATEMENT>discount DISCOUNT
<DYNARE_STATEMENT,DYNARE_BLOCK>varobs VAROBS
<DYNARE_STATEMENT,DYNARE_BLOCK>varexobs VAREXOBS
<DYNARE_STATEMENT,DYNARE_BLOCK>nan NAN_CONSTANT
<DYNARE_STATEMENT,DYNARE_BLOCK>inf INF_CONSTANT
<DYNARE_STATEMENT,DYNARE_BLOCK>constants CONSTANTS

 /* options for GSA module by Marco Ratto */
<DYNARE_STATEMENT>identification IDENTIFICATION
<DYNARE_STATEMENT>morris MORRIS
<DYNARE_STATEMENT>stab STAB
<DYNARE_STATEMENT>redform REDFORM
<DYNARE_STATEMENT>pprior PPRIOR
<DYNARE_STATEMENT>prior_range PRIOR_RANGE
<DYNARE_STATEMENT>ppost PPOST
<DYNARE_STATEMENT>ilptau ILPTAU
<DYNARE_STATEMENT>morris_nliv MORRIS_NLIV
<DYNARE_STATEMENT>morris_ntra MORRIS_NTRA
<DYNARE_STATEMENT>Nsam NSAM
<DYNARE_STATEMENT>load_redform LOAD_REDFORM
<DYNARE_STATEMENT>load_rmse LOAD_RMSE
<DYNARE_STATEMENT>load_stab LOAD_STAB
<DYNARE_STATEMENT>alpha2_stab ALPHA2_STAB
<DYNARE_STATEMENT>logtrans_redform LOGTRANS_REDFORM
<DYNARE_STATEMENT>threshold_redform THRESHOLD_REDFORM
<DYNARE_STATEMENT>ksstat_redform KSSTAT_REDFORM
<DYNARE_STATEMENT>alpha2_redform ALPHA2_REDFORM
<DYNARE_STATEMENT>namendo NAMENDO
<DYNARE_STATEMENT>namlagendo NAMLAGENDO
<DYNARE_STATEMENT>namexo NAMEXO
<DYNARE_STATEMENT>rmse RMSE
<DYNARE_STATEMENT>lik_only LIK_ONLY
<DYNARE_STATEMENT>var_rmse VAR_RMSE
<DYNARE_STATEMENT>pfilt_rmse PFILT_RMSE
<DYNARE_STATEMENT>istart_rmse ISTART_RMSE
<DYNARE_STATEMENT>alpha_rmse ALPHA_RMSE
<DYNARE_STATEMENT>alpha2_rmse ALPHA2_RMSE
<DYNARE_STATEMENT>load_ident_files LOAD_IDENT_FILES
<DYNARE_STATEMENT>useautocorr USEAUTOCORR
<DYNARE_STATEMENT>neighborhood_width NEIGHBORHOOD_WIDTH
<DYNARE_STATEMENT>pvalue_ks PVALUE_KS
<DYNARE_STATEMENT>pvalue_corr PVALUE_CORR
 /* end of GSA options */

 /* For identification() statement */
<DYNARE_STATEMENT>prior_mc PRIOR_MC
<DYNARE_STATEMENT>advanced ADVANCED
<DYNARE_STATEMENT>max_dim_cova_group MAX_DIM_COVA_GROUP
<DYNARE_STATEMENT>gsa_sample_file GSA_SAMPLE_FILE

<DYNARE_STATEMENT>use_shock_groups USE_SHOCK_GROUPS
<DYNARE_STATEMENT>colormap COLORMAP

<DYNARE_STATEMENT,DYNARE_BLOCK>[a-z_][a-z0-9_]* NAME

<DYNARE_STATEMENT,DYNARE_BLOCK>((([0-9]*\.[0-9]+)|([0-9]+\.))([ed][-+]?[0-9]+)?)|([0-9]+[ed][-+]?[0-9]+) FLOAT_NUMBER

<DYNARE_STATEMENT,DYNARE_BLOCK>[0-9]+ INT_NUMBER

<DATES_STATEMENT>\(<>DATES_STATEMENT>
<DATES_STATEMENT>\)<<> DATES
<DATES_STATEMENT>.<.>

<DYNARE_BLOCK>\|e PIPE_E
<DYNARE_BLOCK>\|x PIPE_X
<DYNARE_BLOCK>\|p PIPE_P

<DYNARE_STATEMENT,DYNARE_BLOCK>\'[^\']*\' QUOTED_STRING


 /* Verbatim Block */
<INITIAL>verbatim[[:space:]]*;<VERBATIM_BLOCK>
<VERBATIM_BLOCK>end[[:space:]]*;<INITIAL>	skip()
<VERBATIM_BLOCK>\n<.>
<VERBATIM_BLOCK>.<.>
/*
<VERBATIM_BLOCK><<EOF>> {
                          driver.add_verbatim(eofbuff);
                          yyterminate();
                        }
*/

 /* An instruction starting with a recognized symbol (which is not a modfile local
    or an external function) is passed as NAME, otherwise it is a native statement
    until the end of the line.
    We exclude modfile local vars because the user may want to modify their value
    using a Matlab assignment statement.
    We also exclude external functions because the user may have used a Matlab matrix
    element in initval (in which case Dynare recognizes the matrix name as an external
    function symbol), and may want to modify the matrix later with Matlab statements.
 */
<INITIAL>[a-z_][a-z0-9_]*<DYNARE_STATEMENT>  NAME
//{
//  if (driver.symbol_exists_and_is_not_modfile_local_or_external_function(yytext))
//    {
//      BEGIN DYNARE_STATEMENT;
//      yylval->build<string>(yytext);
//      return token::NAME;
//    }
//  else
//    {
//      /* Enter a native block */
//      BEGIN NATIVE;
//      yyless(0);
//    }
//}

 /*
    For joint prior statement, match [symbol, symbol, ...]
    If no match, begin native and push everything back on stack

    We produce SYMBOL_VEC in Flex (instead of matching `'[' symbol_list ']'`
    in Bison because the pattern also matches potential native statements
    (e.g. function returns from a MATLAB/Octave function). Hence, we need to
    be able to back out of the statement if we realize it's a native statement
    and move to the NATIVE context
 */
<INITIAL>\[([[:space:]]*[a-z_][a-z0-9_]*[[:space:]]*,{1}[[:space:]]*)*([[:space:]]*[a-z_][a-z0-9_]*[[:space:]]*){1}\] SYMBOL_VEC
/*
{
  string yytextcpy{yytext};
  yytextcpy.erase(remove(yytextcpy.begin(), yytextcpy.end(), '['), yytextcpy.end());
  yytextcpy.erase(remove(yytextcpy.begin(), yytextcpy.end(), ']'), yytextcpy.end());
  yytextcpy.erase(remove(yytextcpy.begin(), yytextcpy.end(), ' '), yytextcpy.end());
  istringstream ss(yytextcpy);
  string token;
  vector<string> val;

  bool dynare_statement = true;

  while(getline(ss, token, ','))
    if (driver.symbol_exists_and_is_not_modfile_local_or_external_function(token))
      val.push_back(token);
    else
      {
        BEGIN NATIVE;
        yyless(0);
        dynare_statement = false;
        break;
      }
  if (dynare_statement)
    {
      BEGIN DYNARE_STATEMENT;
      yylval->build<vector<string>>(val);
      return token::SYMBOL_VEC;
    }
}
*/

 /* Enter a native block */
<INITIAL>.<NATIVE> reject()

 /* Add the native statement */
<NATIVE>{
  [^/%*\n\.\'\"]+<.>
  \'<.>
  \'[^\'\n]*\'<.>
  \"[^\"\n]*\"<.>
  \.{1,2}<.>
  \*<.>
  \/<.>
  \.{3,}[[:space:]]*\n<.>
  \n<INITIAL>          skip()
/*
  <<EOF>>                     {
                                driver.add_native(eofbuff);
                                yyterminate();
                              }
*/
  \.{3,}[[:space:]]*%.*\n<.>
  %[^\n]*<.>
  \.{3,}[[:space:]]*"//".*\n<.>
  "//"[^\n]*<.>
  \.{3,}[[:space:]]*"/*"<NATIVE_COMMENT>
  "/*"<>COMMENT>
}

<NATIVE_COMMENT>"*/"[[:space:]]*\n<NATIVE>
<NATIVE_COMMENT>.<.>

/*
<INITIAL,DYNARE_STATEMENT,DYNARE_BLOCK,COMMENT,DATES_STATEMENT,LINE1,LINE2,LINE3,NATIVE_COMMENT><<EOF>> { yyterminate(); }

<*>.      { driver.error(*yylloc, "character unrecognized by lexer"); }
*/

%%
