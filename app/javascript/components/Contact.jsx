import React from 'react'
// import ContactForm from './ContactForm'
// import ContactFormSubmitted from './ContactFormSubmitted'

class Contact extends React.Component {

  state = {contactFormDisplay: true}

  componentDidMount() {
    window.scrollTo(0, 0)
  }

  // hideContactForm = () => {
  //   window.scrollTo(0, 0)
  //   this.setState({ contactFormDisplay: false});
  // }

  // showContactForm = () => {
  //   window.scrollTo(0, 0)
  //   this.setState({ contactFormDisplay: true});
  // }

  render() {
    return (

        <section className="Contact section">
          <div className="container">
            <div className="columns is-centered is-multiline is-mobile">

              <div className="column is-11-mobile is-8-tablet is-8-desktop">
                  <h2 className="title is-3 has-text-centered has-text-weight-semibold has-text-info">Contact</h2>
              </div>

              <div className="column is-11-mobile is-5-tablet is-5-desktop">
                {/* <div className="content is-size-6 is-size-6-mobile">
                  {this.state.contactFormDisplay
                  ? <ContactForm hideContactForm = {this.hideContactForm} />
                  : <ContactFormSubmitted showContactForm = {this.showContactForm}/>
                  }
                </div> */}
              </div>

            </div>
          </div>
        </section>

    )
  }
}

export default Contact