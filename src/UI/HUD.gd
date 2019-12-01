extends Control

#For the pause menu:

func _process(delta: float) -> void:
	if Global.coinsA == Global.coinsMaxA:
		if Global.coinsMaxA == 1:
			$Score/Label.text = ("Congratulations! " + Global.coinsMaxA as String + " Coin Collected!")
		else:
			$Score/Label.text = ("All " + Global.coinsMaxA as String + " Coins Collected!")
	elif Global.coinsA > Global.coinsMaxA:
		$Score/Label.text = ("hold it, you've got " + (Global.coinsA - Global.coinsMaxA) as String + " extra, somehow")
	else:
		$Score/Label.text = (Global.coinsA as String + " / " + Global.coinsMaxA as String + " Coins")
