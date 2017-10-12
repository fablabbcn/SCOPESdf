import MobileDetect from "mobile-detect"

export default function() {
  console.log("-- Detect mobile initialized")

  const md = new MobileDetect(navigator.userAgent)
  const grade = md.mobileGrade()

  Modernizr.addTest({
    mobile: !!md.mobile(),
    phone: !!md.phone(),
    tablet: !!md.tablet(),
    mobilegradea: grade === "A"
  })
}
