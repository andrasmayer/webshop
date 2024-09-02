export class SamplePage{
    constructor(props){
        console.log(props)
        this.props = props
        this.lang = props.lang
    }
    init(){
        return `
            <div>${this.lang.title}
            
    
            
            </div>
            `
    }
    events(){

    }
}