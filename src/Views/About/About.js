export class About{
    constructor(props){
        this.props = props
    }
    init(){
        return `<div>${this.props.lang.title}</div>`
    }
    events(){

    }
}