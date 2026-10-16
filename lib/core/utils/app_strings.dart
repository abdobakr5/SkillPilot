class AppStrings {
  AppStrings._();

  // Branding
  static const String appName = 'SkillPilot';
  static const String appBrandTerminal = '>_';
  static const String appTagline = 'Navigate Your Code Journey';

  // Splash Screen
  static const String splashVersionPrefix = 'v';

  // Onboarding - General
  static const String skip = 'Skip';
  static const String continueText = 'Continue';
  static const String getStarted = 'Get Started';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signIn = 'Sign In';

  // Onboarding - Slide 1 (Interactive Roadmaps)
  static const String onb1Category = 'your next chapter';
  static const String onb1Title = 'Interactive Roadmaps';
  static const String onb1Desc =
      'Turn big goals into clear next steps. Follow a hands-on path, built for the engineer you want to become.';
  static const String onb1Filename = 'frontend.roadmap';
  static const String onb1BadgeTitle = 'A clear path forward';
  static const String onb1BadgeSubtitle = 'one skill at a time';
  static const String onb1TrackRole = 'Frontend Engineer';
  static const String onb1TrackProgress = '01 / 12';
  static const String onb1Item1Title = 'HTML & CSS Foundations';
  static const String onb1Item1Subtitle = 'COMPLETED • 4 LESSONS';
  static const String onb1Item2Title = 'React & TypeScript';
  static const String onb1Item2Subtitle = 'UP NEXT • 6 LESSONS';
  static const String onb1Item3Title = 'Ship your first app';
  static const String onb1Item3Subtitle = 'MILESTONE • BUILD A PROJECT';
  static const String onb1Pace = 'Your pace. Your path.';
  static const String onb1ExplorePath = 'Explore path';

  // Onboarding - Slide 2 (Real-World Projects)
  static const String onb2Category = 'less watching, more building.';
  static const String onb2Title = 'Real-World Projects';
  static const String onb2Desc =
      'Go beyond tutorials. Build, test, and ship real applications that make your portfolio stand out.';
  static const String onb2Filename = 'launchpad.ts';
  static const String onb2BadgeTitle = 'First project shipped';
  static const String onb2BadgeSubtitle = '+250 XP unlocked';
  static const String onb2ProjectTitle = 'Build a developer API';
  static const String onb2ProjectNumber = 'PROJECT 01';
  static const String onb2Code1 = 'const app = createApp();';
  static const String onb2Comment1 = '// START WITH A REAL-WORLD BRIEF';
  static const String onb2Code2 = "app.get('/api', handler);";
  static const String onb2Comment2 = '// WRITE CODE • SOLVE PROBLEMS';
  static const String onb2Code3 = 'await app.deploy();';
  static const String onb2Comment3 = '// TEST IT • SHIP IT • OWN IT';
  static const String onb2Lang = 'TypeScript';
  static const String onb2RunCode = 'Run code';

  // Onboarding - Slide 3 (Skill Gap & Readiness)
  static const String onb3Category = 'track every milestone';
  static const String onb3Title = 'Skill Gap & Readiness';
  static const String onb3Desc =
      'Track exactly where you stand. Identify what competencies you mastered, what skills you need next, and your job-readiness.';
  static const String onb3Filename = 'readiness.radar';
  static const String onb3BadgeTitle = 'Level up your profile';
  static const String onb3BadgeSubtitle = 'benchmark against real roles';
  static const String onb3CardHeader = 'Skill Progress & Readiness';
  static const String onb3ReadinessPercentage = '78% READY';
  static const String onb3Skill1Title = 'Mastered Competencies';
  static const String onb3Skill1Sub = 'Clean Arch • State Management • REST APIs';
  static const String onb3BadgeAcquired = 'ACQUIRED';
  static const String onb3Skill2Title = 'Closing The Skill Gap';
  static const String onb3Skill2Sub = 'Unit & Bloc Tests • CI/CD Deployment';
  static const String onb3BadgeInProgress = 'IN PROGRESS';
  static const String onb3Skill3Title = 'Next Target Skill';
  static const String onb3Skill3Sub = 'GraphQL • Microservices Architecture';
  static const String onb3BadgeUpcoming = 'UPCOMING';
  static const String onb3GrowthFooter = 'Continuous Growth';
  static const String onb3ViewRoadmap = 'View Roadmap';

  // ----------------------------------------------------
  // Auth Screen Strings
  // ----------------------------------------------------
  // Segment Switcher
  static const String tabSignIn = 'Sign In';
  static const String tabSignUp = 'Sign Up';

  // Titles & Subtitles
  static const String welcomeBackTitle = 'Welcome Back';
  static const String welcomeBackSubtitle = 'Continue your journey to tech mastery';
  static const String createAccountTitle = 'Create Account';
  static const String createAccountSubtitle = 'Join the online software engineering platform';
  static const String forgotPasswordTitle = 'FORGOT PASSWORD';
  static const String forgotPasswordSubtitle = "WE'LL SEND YOU AN EMAIL TO RESET YOUR PASSWORD";
  static const String setNewPasswordTitle = 'SET NEW PASSWORD';
  static const String setNewPasswordSubtitle = 'Choose a strong password for your account';
  static const String emailConfirmationTitle = 'CONFIRM EMAIL';
  static const String emailConfirmationSubtitle = 'Please check your inbox to confirm your email address';

  // Form Fields & Labels
  static const String labelFullName = 'FULL NAME';
  static const String hintFullName = 'Full Name';
  static const String labelEmailAddress = 'EMAIL ADDRESS';
  static const String hintEmailAddress = 'email@example.com';
  static const String labelPassword = 'PASSWORD';
  static const String hintPassword = '••••••••';
  static const String labelConfirmPassword = 'CONFIRM PASSWORD';
  static const String labelNewPassword = 'NEW PASSWORD';
  static const String labelConfirmNewPassword = 'CONFIRM NEW PASSWORD';
  static const String labelResetToken = 'RESET CODE / TOKEN';
  static const String hintResetToken = 'Paste code received in your email';
  static const String forgotPasswordAction = 'Forgot Password?';
  static const String rememberMe = 'Remember Me';

  // Auth Buttons
  static const String btnStartLearning = 'Start Learning →';
  static const String btnCreateAccount = 'Create Account & Start →';
  static const String btnRequestResetLink = 'Request Reset Link';
  static const String btnResetPassword = 'Reset Password';
  static const String btnBackToSignIn = '← Back to Sign In';
  static const String btnBackToSignInQuestion = 'Back to Sign In?';
  static const String btnHaveResetCode = 'Already have a reset code? Set new password';
  static const String btnRequestNewResetLink = 'Request a new reset link';

  // Social Auth
  static const String orSignInWith = 'OR SIGN IN WITH';
  static const String orSignUpWith = 'OR SIGN UP WITH';
  static const String gitHub = 'GitHub';
  static const String google = 'Google';
  static const String connectingToGitHub = 'Connecting to GitHub OAuth...';
  static const String connectingToGoogle = 'Connecting to Google OAuth...';
  static const String oauthNotice = 'OAuth requires configuring provider credentials on server.';
  static const String msgSigningInWithGoogle = 'Signing in with Google...';
  static const String msgSigningInWithGitHub = 'Redirecting to GitHub authorization...';
  static const String msgOAuthCancelled = 'Sign-in was cancelled.';
  static const String msgOAuthFailed = 'Authentication failed. Please check credentials and try again.';

  // Validation Messages
  static const String valEmailRequired = 'Email is required';
  static const String valEmailInvalid = 'Please enter a valid email address';
  static const String valPasswordRequired = 'Password is required';
  static const String valPasswordMinLength = 'Password must be at least 8 characters';
  static const String valPasswordPolicy = 'Password must contain uppercase, lowercase, number, and special character';
  static const String valConfirmPasswordRequired = 'Please confirm your password';
  static const String valPasswordsDoNotMatch = 'Passwords do not match';
  static const String valFullNameRequired = 'Full name is required';
  static const String valResetTokenRequired = 'Reset token is required';

  // Success Messages
  static const String msgWelcomeBackSuccess = 'Welcome back! Signed in successfully.';
  static const String msgResetEmailSent = 'Reset link sent! Please check your email inbox.';
  static const String msgRegistrationSuccess = 'Account created successfully! Please verify your email.';
  static const String msgPasswordResetSuccess = 'Password has been reset successfully! Please sign in.';
  static const String msgValidatingResetToken = 'Validating reset link...';
  static const String msgResetTokenValid = 'Reset link verified successfully';
  static const String msgResetTokenInvalid = 'Invalid or expired reset token';
  static const String msgOpeningFilePicker = 'Opening file picker (PDF / DOCX)...';
  static const String msgOnboardingComplete = 'Onboarding completed successfully! Welcome to SkillPilot.';

  // ----------------------------------------------------
  // Setup / Journey 2 Strings
  // ----------------------------------------------------
  static const String secureAccountSetup = 'Secure account setup';
  static const String step1Terms = 'Terms & Agreements';
  static const String step2Track = 'Select Track';
  static const String step3Cv = 'CV';

  // Step 1: Terms & Agreements
  static const String welcomeToSkillPilot = 'Welcome to SkillPilot';
  static const String termsSubtitle =
      'Before we get started, please review and accept our Terms of Service and Privacy Policy.';
  static const String termsCardTitle = 'TERMS & AGREEMENTS';
  static const String termsLastUpdated = 'Last updated: October 1, 2026';
  static const String termsAgreementIntro =
      'By using SkillPilot, you agree to these terms. Our platform helps you build real-world skills through guided learning, coding practice, and AI-assisted support.';
  static const String termsSection1Title = '1. User Responsibilities';
  static const String termsSection1Body =
      'Use SkillPilot responsibly and keep your account secure. Run code only in trusted environments. Review AI-generated suggestions for accuracy and safety before using them; you remain responsible for your code.';
  static const String termsSection2Title = '2. Intellectual Property';
  static const String termsSection2Body =
      'You retain ownership of the code and projects you create. Respect third-party licenses and copyrights. SkillPilot\'s learning content, platform, and branding remain the property of their respective owners.';
  static const String termsCheckboxPrompt =
      'I have read and agree to the Terms of Service and Privacy Policy.';
  static const String termsOfServiceLink = 'Terms of Service';
  static const String privacyPolicyLink = 'Privacy Policy';
  static const String btnAgreeAndContinue = 'Agree & Continue →';
  static const String questionsBeforeStart = 'Questions before you start? ';
  static const String contactSupport = 'Contact support ↗';

  // Step 2: Learning Tracks
  static const String chooseLearningTrack = 'Choose Your Learning Track';
  static const String chooseTrackSubtitle =
      'Select the specialization you want to master. You can customize your learning path later.';
  static const String availableTracks = 'AVAILABLE TRACKS';
  static const String selectOneTrackHint = 'Select one track to continue';
  static const String yourSelectedTrack = 'Your selected track';
  static const String nextCv = 'Next: CV';
  static const String btnBack = 'Back';
  static const String btnContinue = 'Continue →';

  // Step 3: Build Developer Profile & CV
  static const String buildDevProfileTitle = 'Build Your Developer Profile';
  static const String buildDevProfileSubtitle =
      'Upload your resume for automated AI extraction, or review and refine your engineering profile directly.';
  static const String dropCvPrompt = 'Drag & Drop your CV / Resume here';
  static const String dropCvSub =
      'Drop your PDF or DOCX file to let our parser populate credentials, projects, and stack strengths.';
  static const String browseFiles = 'Browse Files';
  static const String supportedFilesNote = 'Supported: PDF, DOCX (Max 10MB)';
  static const String neuralExtractionLive = 'Neural Extraction: Live';

  // Profile Sections
  static const String sectionBasicInfo = '1. Basic Information';
  static const String autoFilled = 'Auto-filled';
  static const String labelLocationTimezone = 'LOCATION / TIMEZONE';
  static const String hintLocationTimezone = 'San Francisco, CA (PST / Remote)';
  static const String labelLinkedInProfile = 'LINKEDIN PROFILE';
  static const String hintLinkedInProfile = 'https://linkedin.com/in/alexchen-dev';

  static const String sectionEducation = '2. Education & Credentials';
  static const String oneEntryDetected = '1 Entry Detected';
  static const String sampleDegree = 'M.S. in Computer Science';
  static const String sampleUni = 'University of Washington • Distributed Systems Focus';
  static const String sampleYears = '2019 - 2021';
  static const String addDegreeOrCert = '+ Add Another Degree or Certification';

  static const String sectionProjects = '3. Projects & Work Experience';
  static const String twoItemsParsed = '2 Items Parsed';
  static const String sampleProjectTitle = 'High-Throughput Asynchronous Stream Runtime';
  static const String keyProjectBadge = 'Key Project';
  static const String sampleProjectDesc =
      'Architected a distributed telemetry ingest service handling 120k events/sec using Tokio and gRPC pipelines with sub-5ms p99 latency.';
  static const String sampleJobTitle = 'Staff Engineering Lead • HyperScale Systems';
  static const String sampleJobDesc =
      'Led cloud infrastructure migration to Kubernetes multi-cluster architecture. Reduced cloud compute overhead by 34% annually.';
  static const String addProjectOrExp = '+ Add Another Project / Experience';

  static const String sectionTechnicalSkills = '4. Technical Skills & Stack';
  static const String clickTagToRemove = 'Click tag to remove • Type to add';
  static const String addCustomSkillHint = 'Add custom skill (e.g. Apache Kafka, WebAssembly)';
  static const String btnAdd = 'Add';
  static const String btnFinishSetup = 'Finish Setup & Start Learning →';

  // Home Dashboard
  static const String homeTitle = 'SkillPilot Workspace';
  static const String homeSubtitle = 'Welcome to your developer dashboard';
  static const String homeActiveTrack = 'ACTIVE TRACK';
  static const String homeTrackName = 'Full-Stack Developer';
  static const String homeProgressTitle = 'Your Roadmap Progress';
  static const String homeProgressValue = '35% Completed';
  static const String homeContinueLesson = 'Continue Next Milestone';
  static const String homeExploreRoadmaps = 'Explore Roadmaps';

  // Common Errors
  static const String serverError = 'An error occurred with the server. Please try again later.';
  static const String noInternetConnection = 'No internet connection. Please check your network.';
  static const String cacheError = 'Failed to load local data.';
  static const String unauthorizedError = 'Session expired. Please log in again.';
  static const String unknownError = 'Something went wrong. Please try again.';

  // Common Actions
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String retry = 'Retry';
  static const String submit = 'Submit';
  static const String save = 'Save';
}
