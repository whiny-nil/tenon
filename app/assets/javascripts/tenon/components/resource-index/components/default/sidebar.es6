class DefaultSidebar extends React.Component {
  render() {
    const singular = _.singularize(this.props.title)
    return(
      <div className="sidebar-container">
        <div className="sidebar">
          <div className="content">
            <h2>{this.props.title}</h2>
            {this.renderNewButton()}
          </div>
        </div>
      </div>
    );
  }

  renderNewButton() {
    if (this.props.newPath) {
      return(
        <a href={this.props.newPath} className="btn btn-primary btn-block">
          New {singular}
        </a>);
    }
  }
}

window.ResourceIndexComponents.DefaultSidebar = DefaultSidebar;