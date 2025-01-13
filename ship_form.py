from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
# Underqualified dev can't figure this out: 
# from wtforms.validators import DataRequired, Length, Regexp

class ShipIDForm(FlaskForm):
    search_ship_id = StringField('Ship ID')