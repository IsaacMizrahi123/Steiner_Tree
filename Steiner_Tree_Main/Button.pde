class Button {
	
	color rectColor, textColor;
	boolean selected = false;
	String button_text;
	float rectX, rectY, width, height;
	int value;

	public Button (String text_, float x, float y, float width_, float height_, int value_) {
		button_text = text_;
		rectX = x;
		rectY = y;
		width = width_;
		height = height_;
		value = value_;
	}

	public void draw(float mouseX, float mouseY){
		if (mouseX >= rectX && mouseX <= rectX+width && mouseY >= rectY && mouseY <= rectY+height) { //It is over botton
		    		selected = true; 	rectColor = color(60); textColor = color(255);
		} else { 	selected = false;	rectColor = color(255); textColor=color(0); }

		fill(rectColor);
		stroke(1);
  		rect(rectX, rectY, width, height);

  		fill(textColor);
  		textSize(18);
  		textAlign(CENTER, CENTER);
		text(button_text, rectX, rectY, width, height); 
	}

}