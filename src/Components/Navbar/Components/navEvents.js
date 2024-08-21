let {navMenu} = await import(`./navMenu.js${app_version}`)
const {Langs} = await import(`../../Langs/Langs.js${app_version}`)
const {Ajax} = await import(`../../../Hooks/Ajax/Ajax.js${app_version}`)
const validateMenu = (itm,url,props,title,jobCode)=>{

    return  itm.login == null && url != "#login" || 
            props.authToken.jwt == null && itm.login == null ||
            props.authToken.jwt != null && itm.login == true  && ( itm.auth.includes(jobCode) || itm.auth == null) || 
            props.authToken.jwt != null && itm.login == true && ( itm.auth == null || itm.auth.length == 0)             ?
            `<li class="nav-item">
                <a class="nav-link active" aria-current="page" href="${url}">${title}</a>
            </li>`
            :
            ""
}

export const navEvents = (props) =>{

    const user = Ajax({
        url:"./server/Procedures/Fetch.php",
        method:"post",
        response:"json",
        data:{mode:"fetch",procedure:"userToken",parameters:`'${props.authToken.jwt}'`}
    })

    const curLang = Langs[props.langCode]

    let NavMenu = ``
    Object.keys(navMenu).forEach(key=>{
        const subLinks = navMenu[key].content
        if( props.path[key] != null ){
            NavMenu += validateMenu(props.path[key],key, props, curLang.views[key].title, parseInt(user.jobCode))
        }
        else if(  subLinks != null){
           
            let dropdownItems = ``
            subLinks.forEach(key2=>{
                dropdownItems += validateMenu(props.path[key2],key2, props,curLang.views[key2].title , parseInt(user.jobCode) )
            })
            
            if( dropdownItems != ""){
                NavMenu +=  `
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown_${key}" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    ${curLang.navBar[key]}
                    </a>
                    <ul class="dropdown-menu p-2" aria-labelledby="navbarDropdown_${key}">${dropdownItems}</ul>
                </li>`
            }
        }
    })
    

    const navBar = document.getElementById("navBar")
    const navbarSupportedContent = document.getElementById("navbarSupportedContent")
    navbarSupportedContent.innerHTML = `<a class="navbar-brand" href="#">${curLang.navBar.navBrand}</a>` + navbarSupportedContent.innerHTML
    const navbar_nav = navbarSupportedContent.querySelector(".navbar-nav")

    navbar_nav.innerHTML += NavMenu

    if( props.authToken.jwt !== null){
        navbar_nav.innerHTML += `<button id="logOut" class="btn btn-danger fa fa-power-off position-absolute" style="right:100px;top:15;"></button>`
    }
    const logOut = document.getElementById("logOut")
    if(logOut != null){
        logOut.addEventListener("click",()=>{
            window.localStorage.removeItem("authToken")
            location.href = "#home"
            location.reload();
        })
    }
}