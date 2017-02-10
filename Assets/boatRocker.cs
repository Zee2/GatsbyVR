using UnityEngine;
using System.Collections;

public class boatRocker : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void FixedUpdate () {
        transform.localRotation = Quaternion.Euler(new Vector3(Mathf.Sin(Time.time * 1.1f) * 5, Mathf.Sin(Time.time) * 2, Mathf.Sin(Time.time+0.2f) * 5));
	}
}
