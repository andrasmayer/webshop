const {Home} = await import(`../../Views/Home/Home.js${app_version}`)
const {About} = await import(`../../Views/About/About.js${app_version}`)
const {Error404} = await import(`../../Views/Error404/Error404.js${app_version}`)
const {Login} = await import(`../../Views/Login/Login.js${app_version}`)
const {SamplePage} = await import(`../../Views/SamplePage/SamplePage.js${app_version}`)
export const path = {
    "#home" :{page:Home},
    "#about":{ page:About,login:true,auth:[]},
    "#login":{ page:Login},

    "#samplePage":{ page:SamplePage},
    
    "#error404":{ page:Error404},
}