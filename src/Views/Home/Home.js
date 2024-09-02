export class Home{
    constructor(props){
        console.log(props)
        this.props = props
        this.lang = props.lang
    }
    init(){
        return `
            <div>${this.lang.title}
                <div>Ez egy sima szöveg</div>
                <div>Ez egy fordított szöveg <b>${ this.lang.sampleMessage}</b></div>
                <button class="pusher">${this.lang.pushMe}</button>
            </div>
            `
    }
    events(){
        const pusher = document.querySelector(".pusher")
        pusher.addEventListener("click",()=>{
           alert(this.lang.iveBeenPushed)
        })
    }
}